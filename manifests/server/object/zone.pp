# = Class: vision_icinga2::server::object::zone
#
# == Parameters:
  #
  # [*zone*]
  #
  # Default: $::fqdn
  #
  # [*parent_zone*]
  #
  # Default: undef

class vision_icinga2::server::object::zone (
  String $zone = $::vision_icinga2::server::client_zone,
  $parent_zone = $::vision_icinga2::server::parent_zone,
) {

  $parent_nodes = $::settings::storeconfigs ? {
    true => query_resources(false,
              ['and',
                ['=', 'type', 'Class'],
                ['=', 'title', 'vision_icinga2::client'],
                ['=', ['parameter', 'zone'], $parent_zone]]),
    default => {}
  }

  $child_nodes = $::settings::storeconfigs ? {
    true => query_resources(false,
              ['and',
                ['=', 'type', 'Class'],
                ['=', 'title', 'vision_icinga2::client'],
                ['=', ['parameter', 'parent_zone'], $zone]]),
    default => {}
  }

  if is_string($parent_zone) {
    ::icinga2::object::zone { $zone:
      parent    => $parent_zone,
      endpoints => {
        $zone => {
          host => $zone,
        }
      },
    }
  } else {
    ::icinga2::object::zone { $zone:
      endpoints => {
        $zone => {
          host => $zone,
        }
      },
    }
  }

  # lint:ignore:variable_scope
  each ($parent_nodes) |$parent_node| {
    $parent_params = $parent_node['parameters']

    ::icinga2::object::zone { $parent_params['zone']:
      endpoints => {
        $parent_params['zone'] => {
          host => $parent_params['zone'],
        }
      },
    }
  }

  each ($child_nodes) |$child_node| {
    $child_params = $child_node['parameters']

    ::icinga2::object::zone { $child_params['zone']:
      parent    => $zone,
      endpoints => {
        $child_params['zone'] => {
          host => $child_params['zone'],
        }
      },
    }
  }
  # lint:endignore
}
