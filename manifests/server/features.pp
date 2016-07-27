# Class: vision_icinga2::common::features
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

class vision_icinga2::server::features (
  Boolean $graphite_enable = $::vision_icinga2::server::graphite_enable,
  String  $graphite_host   = $::vision_icinga2::server::graphite_host,
  Integer $graphite_port   = $::vision_icinga2::server::graphite_port,
) {
  contain ::vision_icinga2::common::features

  contain ::icinga2::feature::notification

  if $graphite_enable {
    class { '::icinga2::feature::graphite':
      host => $graphite_host,
      port => $graphite_port,
    }
  }
}
