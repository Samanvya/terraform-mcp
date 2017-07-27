/*
 * This configuration will create a Cloud Server
 *
 */
 
resource "ddcloud_server" "dd_svr_jum_01" {
  name                 = "dd_svr_jum_01"
  description          = "This is my DevOps test server."
  admin_password       = "password"

  memory_gb            = 8
  cpu_count            = 2

  networkdomain        = "${ddcloud_networkdomain.dd_domain01.id}"
   
  primary_network_adapter = {
    ipv4               = "192.168.1.6"
  }

  dns_primary          = "8.8.8.8"
  dns_secondary        = "8.8.4.4"

  image                = "CentOS 7 64-bit 2 CPU"

  # The image disk (part of the original server image). If size_gb is larger than the image disk's original size, it will be expanded (specifying a smaller size is not supported).
  # You don't have to specify this but, if you don't, then Terraform will keep treating the ddcloud_server resource as modified.
  disk {
    scsi_unit_id       = 0
    size_gb            = 20
  }

  depends_on           = [ "ddcloud_vlan.dd_vlan01" ]
}

resource "ddcloud_server" "dd_svr_lin_01" {
  name                 = "dd_svr_lin_01"
  description          = "This is my DevOps test server."
  admin_password       = "password"

  memory_gb            = 8
  cpu_count            = 2

  networkdomain        = "${ddcloud_networkdomain.dd_domain01.id}"
   
  primary_network_adapter = {
    ipv4               = "192.168.10.6"
  }

  dns_primary          = "8.8.8.8"
  dns_secondary        = "8.8.4.4"

  image                = "CentOS 7 64-bit 2 CPU"

  # The image disk (part of the original server image). If size_gb is larger than the image disk's original size, it will be expanded (specifying a smaller size is not supported).
  # You don't have to specify this but, if you don't, then Terraform will keep treating the ddcloud_server resource as modified.
  disk {
    scsi_unit_id       = 0
    size_gb            = 20
  }

  # An additional disk.
  disk {
    scsi_unit_id       = 1
    size_gb            = 20
  }

  depends_on           = [ "ddcloud_vlan.dd_vlan02" ]
}