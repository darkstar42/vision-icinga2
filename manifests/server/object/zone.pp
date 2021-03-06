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
  String $zone = $::vision_icinga2::client_zone,
  $parent_zone = $::vision_icinga2::parent_zone,
) {

  $parent_nodes = $::settings::storeconfigs ? {
    true => query_resources(false,
              ['and',
                ['=', 'type', 'Class'],
                ['=', 'title', 'Vision_icinga2'],
                ['=', ['parameter', 'client_zone'], $parent_zone]]),
    default => {}
  }

  $child_nodes = $::settings::storeconfigs ? {
    true => query_resources(false,
              ['and',
                ['=', 'type', 'Class'],
                ['=', 'title', 'Vision_icinga2'],
                ['=', ['parameter', 'parent_zone'], $zone]]),
    default => {}
  }

  if !defined(Icinga2::Object::Zone[$zone]) {
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

    file { "/etc/icinga2/zones.d/${zone}":
      ensure => directory,
      owner  => nagios,
      group  => nagios,
    }
  }

  # lint:ignore:variable_scope
  each ($parent_nodes) |$parent_node| {
    $parent_params = $parent_node['parameters']

    file { "/etc/icinga2/zones.d/${parent_params['client_zone']}":
      ensure => directory,
      owner  => nagios,
      group  => nagios,
    }

    ::icinga2::object::zone { $parent_params['client_zone']:
      endpoints => {
        $parent_params['client_zone'] => {
          host => $parent_params['client_zone'],
        }
      },
    }
  }

  each ($child_nodes) |$child_node| {
    $child_params = $child_node['parameters']

    if is_string($child_params['client_zone']) {
      if !defined(Icinga2::Object::Zone[$child_params['client_zone']]) {
        ::icinga2::object::zone { $child_params['client_zone']:
          parent    => $zone,
          endpoints => {
            $child_params['client_zone'] => {
              host => $child_params['client_zone'],
            }
          },
        }

        file { "/etc/icinga2/zones.d/${child_params['client_zone']}":
          ensure => directory,
          owner  => nagios,
          group  => nagios,
        }
      }
    }
  }
  # lint:endignore
}
