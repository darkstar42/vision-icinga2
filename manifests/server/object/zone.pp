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
  $zone = hiera('icinga2::client::zone', $::fqdn),
  $parent_zone = hiera('icinga2::client::parent_zone', undef),
) {

  $parent_nodes = query_resources(false,
    ['and',
      ['=', 'type', 'Class'],
      ['=', 'title', 'vision_icinga2::Base::Monitoring'],
      ['=', ['parameter', 'zone'], $parent_zone]]);

  $child_nodes = query_resources(false,
    ['and',
      ['=', 'type', 'Class'],
      ['=', 'title', 'vision_icinga2::Base::Monitoring'],
      ['=', ['parameter', 'parent_zone'], $zone]]);

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
