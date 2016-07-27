# Class: vision_icinga2::server
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_icinga2
#

class vision_icinga2::server (
  String  $zone = $::fqdn,
  String  $mysql_database,
  String  $mysql_user,
  String  $mysql_password,
  String  $mysql_host,
  Integer $mysql_port,
  Boolean $graphite_enable,
  String  $graphite_host,
  Integer $graphite_port,
  String  $api_user,
  String  $api_password,
) {
  contain ::vision_icinga2::server::install
  contain ::vision_icinga2::server::features
  contain ::vision_icinga2::server::object
}
