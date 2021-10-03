data "vsphere_datacenter" "dc" {
  name = var.tkg_env.datacenter_name
}

data "vsphere_compute_cluster" "cluster" {
    name          = var.tkg_env.cluster_name
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
    name          = var.tkg_env.datastore_name
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
    name          = var.tkg_network.network_id
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_content_library" "tkg_library" {
    name = var.tkg_env.content_catalog_name
}

data "vsphere_content_library_item" "bootvm" {
  name = var.tkg_bootvm.image_name
  type = "OVF"
  library_id  = data.vsphere_content_library.tkg_library.id
}







