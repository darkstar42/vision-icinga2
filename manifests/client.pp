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

  ::icinga2::object::endpoint { $::fqdn:
    host => $::fqdn,
  }

  ::icinga2::object::zone { $::fqdn:
    parent    => $parent_zone,
    endpoints => {
      $::fqdn => {}
    }
  }

  ::icinga2::object::endpoint { $parent_zone:
    host => $parent_zone
  }

  ::icinga2::object::zone { $parent_zone:
    parent    => $parent_zone,
    endpoints => {
      $::fqdn => {}
    }
  }
}
