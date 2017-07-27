/*
 * This configuration will create a Network domain01
 *
 */

variable "mcp-pass" {}

provider "ddcloud" {
  # User name and password can also be specified via MCP_USER and MCP_PASSWORD environment variables.
  "username"           = "samanvya.nayyar"
  "password"           = "${var.mcp-pass}" # Watch out for escaping if your password contains characters such as "$".
  "region"             = "AP" # The DD compute region code (e.g. "AU", "NA", "EU")
}

resource "ddcloud_networkdomain" "dd_domain01" {
  name                 = "dd_domain01"
  description          = "This is my dd test network domain01."
  datacenter           = "AP3" # The ID of the data centre in which to create your network domain01.
}

resource "ddcloud_vlan" "dd_vlan01" {
  name                 = "dd_vlan01"
  description          = "This is my dd test VLAN."

  networkdomain        = "${ddcloud_networkdomain.dd_domain01.id}"

  # VLAN's default network: 192.168.1.1 -> 192.168.1.254 (netmask = 255.255.255.0)
  ipv4_base_address    = "192.168.1.0"
  ipv4_prefix_size     = 24

  depends_on           = [ "ddcloud_networkdomain.dd_domain01"]
}

resource "ddcloud_vlan" "dd_vlan02" {
  name                 = "dd_vlan02"
  description          = "This is my dd test VLAN."

  networkdomain        = "${ddcloud_networkdomain.dd_domain01.id}"

  # VLAN's default network: 192.168.10.1 -> 192.168.10.254 (netmask = 255.255.255.0)
  ipv4_base_address    = "192.168.10.0"
  ipv4_prefix_size     = 24

  depends_on           = [ "ddcloud_networkdomain.dd_domain01"]
}
resource "ddcloud_port_list" "dd_portlist01" {
  name                = "dd_portlist01"
  description         = "d_22_80_443"

 networkdomain        = "${ddcloud_networkdomain.dd_domain01.id}"

  port {
      begin = 22
  }

  port {
      begin = 80
  }

  port {
      begin = 443
  }

    
  depends_on           = [ "ddcloud_networkdomain.dd_domain01"]
}

resource "ddcloud_firewall_rule" "dd_fwrule01" {
  name                = "dd_fwrule01"
  placement           = "first"
  action              = "accept"
  enabled             = true
  ip_version          = "ipv4"
  protocol            = "tcp"
  source_network      = "202.83.108.84/32"
  destination_network = "168.128.148.146/32"
  destination_port    = "22"
  
 networkdomain        = "${ddcloud_networkdomain.dd_domain01.id}"
   depends_on           = [ "ddcloud_networkdomain.dd_domain01"]
}

resource "ddcloud_firewall_rule" "dd_fwrule02" {
  name                = "dd_fwrule02"
  placement           = "first"
  action              = "accept"
  enabled             = true
  ip_version          = "ipv4"
  protocol            = "tcp"
  source_network      = "192.168.1.0/24"
  destination_network = "192.168.10.0/24"
  destination_port_list = "${ddcloud_port_list.dd_portlist01.id}"
  
 networkdomain        = "${ddcloud_networkdomain.dd_domain01.id}"
   depends_on           = [ "ddcloud_networkdomain.dd_domain01"]
}

resource "ddcloud_firewall_rule" "dd_fwrule03" {
  name                = "dd_fwrule03"
  placement           = "first"
  action              = "accept"
  enabled             = true
  ip_version          = "ipv4"
  protocol            = "tcp"
  source_network      = "192.168.10.0/24"
  destination_network = "192.168.1.0/24"
  destination_port = "22"
  
 networkdomain        = "${ddcloud_networkdomain.dd_domain01.id}"
   depends_on           = [ "ddcloud_networkdomain.dd_domain01"]
}