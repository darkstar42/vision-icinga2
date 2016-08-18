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

) {
  contain ::vision_icinga2::common::install

  contain ::vision_icinga2::common::features
  contain ::vision_icinga2::server::features

  contain ::vision_icinga2::common::object
  class { '::vision_icinga2::server::object':
    api_user     => $api_user,
    api_password => $api_password,
  }
}
