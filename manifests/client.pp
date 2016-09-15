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

class vision_icinga2::client {
  contain ::vision_icinga2::common::install
  contain ::vision_icinga2::client::install

  contain ::vision_icinga2::common::features
  contain ::vision_icinga2::common::object

  ::icinga2::object::zone { $::fqdn:
    parent    => $::vision_icinga2::parent_zone,
    endpoints => {
      $::fqdn => {}
    }
  }

  ::icinga2::object::zone { $::vision_icinga2::parent_zone:
    endpoints => {
      $::vision_icinga2::parent_zone => {}
    }
  }

  # We can only use the query resource if a puppetdb is available.
  # This is usually not the case during a bootstrap
  $child_nodes = $::settings::storeconfigs ? {
    true => query_resources(false,
              ['and',
                ['=', 'type', 'Class'],
                ['=', 'title', 'Vision_icinga2'],
                ['=', ['parameter', 'parent_zone'], $::fqdn]]),
    default => {}
  }

  each ($child_nodes) |$child_node| {
    ::icinga2::object::zone { $child_node['certname']:
      parent    => $::fqdn,
      endpoints => {
        $child_node['certname'] => {
          host => $child_node['certname'],
        }
      },
    }
  }
}
