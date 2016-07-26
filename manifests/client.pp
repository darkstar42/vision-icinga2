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

  $child_nodes = query_resources(false,
    ['and',
      ['=', 'type', 'Class'],
      ['=', 'title', 'Vision_icinga2::Client'],
      ['=', ['parameter', 'parent_zone'], $::fqdn]]);


  each ($child_nodes) |$child_node| {
    $child_params = $child_node['parameters']

    ::icinga2::object::zone { $child_params['name']:
      parent    => $::fqdn,
      endpoints => {
       $child_params['name'] => {
         host => $child_params['name'],
       }
      },
    }
  }
}
