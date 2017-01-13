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
  String $zone = $::vision_icinga2::zone,
) {

  # Master Zone

  ::icinga2::object::zone { $zone:
    endpoints => [ $zone ],
  }

  ::icinga2::object::endpoint { $zone:
    host => $::vision_icinga2::api_host,
    port => $::vision_icinga2::api_port,
  }

  file { "/etc/icinga2/zones.d/${zone}":
    ensure  => directory,
    owner   => nagios,
    group   => nagios,
    recurse => true,
    purge   => true,
  }


  # Child Zones

  $nodes = $::settings::storeconfigs ? {
    true => query_resources(false,
      ['and',
        ['=', 'type', 'Class'],
        ['=', 'title', 'Vision_icinga2']]),
    default => {}
  }

  each ($nodes) |$node| {
    $node_params = $node['parameters']

    if $node_params['zone'] != $zone {

      ::icinga2::object::zone { $node_params['zone']:
        endpoints => [ $node_params['zone'] ],
        parent    => ($node_params['parent_zone'] == undef) ? {
          true    => undef,
          default => $node_params['parent_zone'],
        }
      }

      ::icinga2::object::endpoint { $node_params['zone']:
        host => $node_params['api_host'],
        port => $node_params['api_port'],
      }

      file { "${::icinga2::params::conf_dir}/zones.d/${node_params['zone']}":
        ensure  => directory,
        owner   => nagios,
        group   => nagios,
        recurse => true,
        purge   => true,
      }
    }
  }

  /*

  $parent_nodes = $::settings::storeconfigs ? {
    true => query_resources(false,
              ['and',
                ['=', 'type', 'Class'],
                ['=', 'title', 'Vision_icinga2'],
                ['=', ['parameter', 'zone'], $parent_zone]]),
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

    file { "/etc/icinga2/zones.d/${parent_params['zone']}":
      ensure => directory,
      owner  => nagios,
      group  => nagios,
    }

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

    if is_string($child_params['zone']) {
      if !defined(Icinga2::Object::Zone[$child_params['zone']]) {
        ::icinga2::object::zone { $child_params['zone']:
          parent    => $zone,
          endpoints => {
            $child_params['zone'] => {
              host => $child_params['zone'],
            }
          },
        }

        file { "/etc/icinga2/zones.d/${child_params['zone']}":
          ensure => directory,
          owner  => nagios,
          group  => nagios,
        }
      }
    }
  }
  # lint:endignore
  */
}
