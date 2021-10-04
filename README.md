<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_sshclient"></a> [sshclient](#requirement\_sshclient) | 1.0.1 |
| <a name="requirement_sshcommand"></a> [sshcommand](#requirement\_sshcommand) | 0.2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_sshclient"></a> [sshclient](#provider\_sshclient) | 1.0.1 |
| <a name="provider_sshcommand"></a> [sshcommand](#provider\_sshcommand) | 0.2.2 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |
| <a name="provider_vsphere"></a> [vsphere](#provider\_vsphere) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.get_kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.create_mgmtcluster](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.vm_ready](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.kickoffvm_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [sshclient_run.bootvm_createdir](https://registry.terraform.io/providers/luma-planet/sshclient/1.0.1/docs/resources/run) | resource |
| [sshclient_run.bootvm_sshkeygen](https://registry.terraform.io/providers/luma-planet/sshclient/1.0.1/docs/resources/run) | resource |
| [sshclient_scp_put.bootvm_tpl_mgmt](https://registry.terraform.io/providers/luma-planet/sshclient/1.0.1/docs/resources/scp_put) | resource |
| [time_sleep.wait_60_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [vsphere_virtual_machine.kickoffvm](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) | resource |
| [sshclient_host.bootvm_keyscan](https://registry.terraform.io/providers/luma-planet/sshclient/1.0.1/docs/data-sources/host) | data source |
| [sshclient_host.bootvm_main](https://registry.terraform.io/providers/luma-planet/sshclient/1.0.1/docs/data-sources/host) | data source |
| [sshclient_keyscan.bootvm](https://registry.terraform.io/providers/luma-planet/sshclient/1.0.1/docs/data-sources/keyscan) | data source |
| [sshcommand_command.get_kubectl](https://registry.terraform.io/providers/invidian/sshcommand/0.2.2/docs/data-sources/command) | data source |
| [sshcommand_command.get_rsa](https://registry.terraform.io/providers/invidian/sshcommand/0.2.2/docs/data-sources/command) | data source |
| [template_file.tkg-mgmt-template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [vsphere_compute_cluster.cluster](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/compute_cluster) | data source |
| [vsphere_content_library.tkg_library](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/content_library) | data source |
| [vsphere_content_library_item.bootvm](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/content_library_item) | data source |
| [vsphere_datacenter.dc](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datacenter) | data source |
| [vsphere_datastore.datastore](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datastore) | data source |
| [vsphere_network.network](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_output_path"></a> [output\_path](#input\_output\_path) | Local path folder for input/output files (kubectl) | `string` | `"."` | no |
| <a name="input_tkg_bootvm"></a> [tkg\_bootvm](#input\_tkg\_bootvm) | All settings for BootVM | <pre>object({<br>        image_name = string<br>        name = string<br>        ip = string<br>        hostname = string<br>    })</pre> | <pre>{<br>  "hostname": "bootstrap",<br>  "image_name": "TKG-Demo-Appliance-1.3.1",<br>  "ip": "192.168.206.10",<br>  "name": "bootvm"<br>}</pre> | no |
| <a name="input_tkg_env"></a> [tkg\_env](#input\_tkg\_env) | All Environment elements to place TKG clusters | <pre>object({<br>        datacenter_name = string<br>        cluster_name = string<br>        resource_pool = string<br>        datastore_name = string<br>        datastore_url = string<br>        vm_folder = string<br>        content_catalog_name = string<br>    })</pre> | <pre>{<br>  "cluster_name": "workload",<br>  "content_catalog_name": "TKG DEMO",<br>  "datacenter_name": "HomeLabWorkload",<br>  "datastore_name": "datastore1",<br>  "datastore_url": "ds:///vmfs/volumes/5b0b0910-295caf38-a57d-ac1f6b1bfc94/",<br>  "resource_pool": "TKG",<br>  "vm_folder": "tkgvms"<br>}</pre> | no |
| <a name="input_tkg_mgmt"></a> [tkg\_mgmt](#input\_tkg\_mgmt) | All elements required Management Cluster | <pre>object({<br>        ip = string<br>        loadbalancer_cidr = string<br>    })</pre> | <pre>{<br>  "ip": "192.168.206.11",<br>  "loadbalancer_cidr": "192.168.206.60-192.168.206.70"<br>}</pre> | no |
| <a name="input_tkg_network"></a> [tkg\_network](#input\_tkg\_network) | All networking elements for TKG Clusters | <pre>object({<br>        network_id = string<br>        gateway = string<br>        netmask = string<br>        dns = string<br>        domain = string<br>        vip_address = string<br>        workload_address = string<br>    })</pre> | <pre>{<br>  "dns": "192.168.200.10",<br>  "domain": "local",<br>  "gateway": "192.168.206.1",<br>  "netmask": "24 (255.255.255.0)",<br>  "network_id": "dpgTKG",<br>  "vip_address": "192.168.206.20-192.168.206.30",<br>  "workload_address": "192.168.206.40-192.168.206.50"<br>}</pre> | no |
| <a name="input_vsphere_env"></a> [vsphere\_env](#input\_vsphere\_env) | vCenter connection variables | <pre>object({<br>        server = string<br>        user = string<br>        password = string<br>    })</pre> | <pre>{<br>  "password": "VMware1!",<br>  "server": "vcsa.local.lab",<br>  "user": "admin@vsphere.local"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bootstrap_server_ip"></a> [bootstrap\_server\_ip](#output\_bootstrap\_server\_ip) | n/a |
| <a name="output_bootstrap_server_root_password"></a> [bootstrap\_server\_root\_password](#output\_bootstrap\_server\_root\_password) | n/a |
| <a name="output_kubctl_config"></a> [kubctl\_config](#output\_kubctl\_config) | n/a |
<!-- END_TF_DOCS -->