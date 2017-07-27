resource "ddcloud_nat" "dd_nat01" {
  networkdomain       = "${ddcloud_networkdomain.dd_domain01.id}"
  private_ipv4        = "${ddcloud_server.dd_svr_jum_01.primary_adapter_ipv4}"

  # public_ipv4 is computed at deploy time.

  depends_on          = [ "ddcloud_vlan.dd_vlan01" ]
}