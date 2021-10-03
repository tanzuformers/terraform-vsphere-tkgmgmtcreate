
resource "vsphere_virtual_machine" "kickoffvm" {
    annotation = "Version: 1.3.1"
	name= var.tkg_bootvm.name
    resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
	datastore_id = data.vsphere_datastore.datastore.id
	folder = var.tkg_env.vm_folder
	num_cpus = 2
	memory = 8192
	wait_for_guest_net_timeout = 0

	network_interface {
		network_id = data.vsphere_network.network.id
	}
	
    disk {
        label = "disk0"
        size = 20
        thin_provisioned = true
    }

	clone {
		template_uuid = data.vsphere_content_library_item.bootvm.id
	}

    vapp {
        properties = {
            "guestinfo.hostname" = var.tkg_bootvm.hostname
            "guestinfo.ipaddress" = var.tkg_bootvm.ip
            "guestinfo.netmask" = var.tkg_network.netmask
            "guestinfo.gateway" = var.tkg_network.gateway
            "guestinfo.dns" = var.tkg_network.dns
            "guestinfo.domain" = var.tkg_network.domain
            "guestinfo.ntp" = "time.ien.it"
            "guestinfo.root_password" = random_password.kickoffvm_password.result
            "guestinfo.root_ssh_key" = "" # optional
            "guestinfo.http_proxy" = "" #optional
            "guestinfo.https_proxy" = "" #optional
            "guestinfo.proxy_username" = "" #optional
            "guestinfo.proxy_password" = "" #optional
            "guestinfo.no_proxy" = "" #optional
            
        }
    }

    lifecycle {
        ignore_changes = [
            id,
            name,
            tags,
            vapp
        ]
    }

}

resource "null_resource" "vm_ready" {
    depends_on = [
        vsphere_virtual_machine.kickoffvm
    ]
    provisioner "remote-exec" {
 		inline = [
 		    "ls -lha"
 		]
 		connection {
 		    host = var.tkg_bootvm.ip
 		    type     = "ssh"
 			user     = "root"
 			password = random_password.kickoffvm_password.result
 		}
 	}
}


resource "time_sleep" "wait_60_seconds" {
  depends_on = [null_resource.vm_ready]

  create_duration = "60s"
}


#### SSH Host defintion
data "sshclient_host" "bootvm_keyscan" {
    depends_on = [
    null_resource.vm_ready
    ]
  hostname                 = var.tkg_bootvm.ip
  port                     = 22
  username                 = "root"
  insecure_ignore_host_key = true
}

data "sshclient_keyscan" "bootvm" {
  host_json = data.sshclient_host.bootvm_keyscan.json
}

data "sshclient_host" "bootvm_main" {
  extends_host_json = data.sshclient_host.bootvm_keyscan.json
  password          = random_password.kickoffvm_password.result
  host_publickey_authorized_key = data.sshclient_keyscan.bootvm.authorized_key
}


resource "sshclient_run" "bootvm_createdir" {
    depends_on = [
        null_resource.vm_ready
    ]
    host_json         = data.sshclient_host.bootvm_main.json
    command           = "mkdir /root/tkglab"
    destroy_command   = "rm -fr /root/tkglab"
}

resource "sshclient_run" "bootvm_sshkeygen" {
    depends_on = [
        null_resource.vm_ready
    ]
    host_json         = data.sshclient_host.bootvm_main.json
    command           = "ssh-keygen -f /root/.ssh/id_rsa -N \"\""
    destroy_command   = "rm /root/.ssh/id_rsa"
}

data "sshcommand_command" "get_rsa" {
    depends_on = [
      sshclient_run.bootvm_sshkeygen
    ]
    host = var.tkg_bootvm.ip
    user = "root"
    password = random_password.kickoffvm_password.result
    command = "cat /root/.ssh/id_rsa.pub"
}
