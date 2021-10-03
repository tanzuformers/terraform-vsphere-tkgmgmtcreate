### Cluster + MetalLB + Default Storage Class

data "template_file" "tkg-mgmt-template" {
    template = file("${path.module}/mgmt/vsphere-tkg-mgmt-template.yaml")
    vars = {
        CLUSTER_NAME = "mgmt"
        VSPHERE_SERVER = var.vsphere_env.server
        VSPHERE_USERNAME = var.vsphere_env.user
        VSPHERE_PASSWORD = var.vsphere_env.password
        VSPHERE_DATACENTER: join("",["/",var.tkg_env.datacenter_name])
        VSPHERE_RESOURCE_POOL:  join("/",["",var.tkg_env.datacenter_name,"host",var.tkg_env.cluster_name,"Resources",var.tkg_env.resource_pool])
        VSPHERE_DATASTORE: join("/",["",var.tkg_env.datacenter_name,"datastore",var.tkg_env.datastore_name])
        VSPHERE_FOLDER: join("/",["",var.tkg_env.datacenter_name,"vm",var.tkg_env.vm_folder])
        VSPHERE_NETWORK: var.tkg_network.network_id
        VSPHERE_CONTROL_PLANE_ENDPOINT: var.tkg_mgmt.ip
        VSPHERE_SSH_AUTHORIZED_KEY: chomp(data.sshcommand_command.get_rsa.result)
    }
}

resource "sshclient_scp_put" "bootvm_tpl_mgmt" {
    depends_on = [
        sshclient_run.bootvm_createdir
    ]
    host_json   = data.sshclient_host.bootvm_main.json
    data = data.template_file.tkg-mgmt-template.rendered
    remote_path = "/root/tkglab/vsphere-tkg-mgmt-template.yaml"
    permissions = "664"
}

resource "null_resource" "create_mgmtcluster" {
    depends_on = [
        sshclient_scp_put.bootvm_tpl_mgmt,
        time_sleep.wait_60_seconds
    ]

    provisioner "remote-exec" {
 		inline = [
 		    "tanzu management-cluster create -f tkglab/vsphere-tkg-mgmt-template.yaml -v2"
 		]
 		connection {
 		    host = var.tkg_bootvm.ip
 		    type     = "ssh"
 			user     = "root"
 			password = random_password.kickoffvm_password.result
 		}
 	}
}

data "sshcommand_command" "get_kubectl" {
    depends_on = [
      null_resource.create_mgmtcluster
    ]
    host = var.tkg_bootvm.ip
    user = "root"
    password = random_password.kickoffvm_password.result
    command = "cat /root/.kube/config && cp /root/.kube/config /root/tkglab/mgmt-kubeconfig"
}


#get kubeconfig
resource "local_file" "get_kubeconfig" {
    content      = data.sshcommand_command.get_kubectl.result
    filename = "${var.output_path}/kubeconfig"
}
