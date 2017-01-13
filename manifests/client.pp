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
# contain ::vision_icinga2::client
#
#
class vision_icinga2::client (

  String $zone = $::vision_icinga2::zone,
  Optional[String] $parent_zone = $::vision_icinga2::parent_zone,

) {

  contain ::vision_icinga2::common::install
  contain ::vision_icinga2::client::install

  contain ::vision_icinga2::common::features
  contain ::vision_icinga2::common::object

  # Client Zone
  ::icinga2::object::zone { $zone:
    parent    => $parent_zone,
    endpoints => [ $zone ],
  }

  ::icinga2::object::endpoint { $zone:
    host => $::vision_icinga2::api_host,
    port => $::vision_icinga2::api_port,
  }

  # Parent Zone

  # We can only use the query resource if a puppetdb is available.
  # This is usually not the case during a bootstrap
  $parent_nodes = $::settings::storeconfigs ? {
    true => query_resources(false,
      ['and',
        ['=', 'type', 'Class'],
        ['=', 'title', 'Vision_icinga2'],
        ['=', ['parameter', 'zone'], $parent_zone]]),
    default => {}
  }

  each ($parent_nodes) |$parent_node| {
    $parent_params = $parent_node['parameters']

    ::icinga2::object::zone { $parent_node['certname']:
      endpoints => [ $parent_node['certname'] ]
    }

    ::icinga2::object::endpoint { $parent_node['certname']:
      host => $parent_params['api_host'],
      port => $parent_params['api_port'],
    }
  }

  # Child Zones

  # We can only use the query resource if a puppetdb is available.
  # This is usually not the case during a bootstrap
  $child_nodes = $::settings::storeconfigs ? {
    true => query_resources(false,
              ['and',
                ['=', 'type', 'Class'],
                ['=', 'title', 'Vision_icinga2'],
                ['=', ['parameter', 'parent_zone'], $zone]]),
    default => {}
  }

  each ($child_nodes) |$child_node| {
    $child_params = $child_node['parameters']

    ::icinga2::object::zone { $child_node['certname']:
      parent    => $zone,
      endpoints => [ $child_node['certname'] ]
    }

    ::icinga2::object::endpoint { $child_node['certname']:
      host => $child_params['api_host'],
      port => $child_params['api_port'],
    }
  }
}
