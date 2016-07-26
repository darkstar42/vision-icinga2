# Class: vision_icinga2::client
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

class vision_icinga2::client (
  String $parent_zone
) {
  contain ::vision_icinga2::common::install

  contain ::vision_icinga2::common::features
  contain ::vision_icinga2::common::object

  contain ::vision_monitoring

  ::icinga2::object::zone { $::fqdn:
    parent    => $parent_zone,
    endpoints => {
      $::fqdn => {}
    }
  }

  ::icinga2::object::zone { $parent_zone:
    endpoints => {
      $parent_zone => {}
    }
  }
}
