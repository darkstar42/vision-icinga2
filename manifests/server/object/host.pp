# = Class: vision_icinga2::commong::object::host
class vision_icinga2::server::object::host () {
  # lint:ignore:variable_scope
  $child_nodes = $::settings::storeconfigs ? {
    # collect all nodes that have their parent zone configured to be
    # in this servers client zone
    true => query_resources(false,
              ['and',
                ['=', 'type', 'Class'],
                ['=', 'title', 'Vision_icinga2'],
                #['=', ['parameter', 'parent_zone'], $::vision_icinga2::client_zone]
              ]),
    default => {}
  }

  each ($child_nodes) |$child_node| {
    $child_params = $child_node['parameters']

      #::icinga2::object::host { "${child_node}":
      #    target_file_name => "${child_node}.conf"
      #  }

    $hosts = query_resources(false,
      ['and',
        ['=', 'type', 'Icinga2::Object::Host'],
        ['=', 'certname', $child_node['certname']]])

    each ($hosts) |$host| {
      $host_params = $host['parameters']

      # get the endpoint on which remote checks should be executed
      # this is usually the client's first parent
      # dir01 -> dom0 -> mon_primary
      # the query asks for all client parameters, which are search for its
      # parent_zone.
      $endpoint = query_resources(false,
        ['and',
          ['=', 'type', 'Class'],
          ['=', 'title', 'Vision_icinga2'],
          ['=', 'certname', $host['title']]
        ]
      );

      $overwrite_vars = {
        'remote_client' => $child_node['certname'],
      }
      $vars = merge($host_params['vars'], $overwrite_vars)

      if (!defined(::Icinga2::Object::Host[$host['title']]) and $host['title'] != $::fqdn) {
        ::icinga2::object::host { $host['title']:
          display_name     => $host_params['display_name'],
          ipv4_address     => $host_params['ipv4_address'],
          vars             => $vars,
          target_dir       => "/etc/icinga2/zones.d/${vars['parent']}",
          target_file_name => "host_${host_params['target_file_name']}",
          command_endpoint => $child_node['certname'],
          require          => File["/etc/icinga2/zones.d/${vars['parent']}"],
        }

        if !defined(Icinga2::Object::Zone[$host['title']]) {
          ::icinga2::object::zone { $host['title']:
            parent    => $vars['parent'],
            endpoints => {
              $host['title'] => {
                host => $host['title'],
              }
            },
          }

          file { "/etc/icinga2/zones.d/${host['title']}":
            ensure => directory,
            owner  => nagios,
            group  => nagios,
          }
        }

        # ::icinga2::object::apply_dependency { "parent-${host['title']}":
        #   parent_host_name      => $host['title'],
        #   assign_where          => "host.address && host.vars.parent && host.vars.parent == \"${host['title']}\"",
        #   disable_notifications => true,
        #   disable_checks        => true
        # }

      }
    }
  }

  # lint:endignore
}
