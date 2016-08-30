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
  String $api_user,
  String $api_password,

  String $mysql_user,
  String $mysql_password,
  String $mysql_database,
  String $mysql_root_password,

) {
  contain ::vision_icinga2::common::install
  contain ::vision_icinga2::server::install

  contain ::vision_icinga2::common::features
  contain ::vision_icinga2::server::features

  contain ::vision_icinga2::common::object
  contain ::vision_icinga2::server::object
}
