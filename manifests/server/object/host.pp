# = Class: vision_icinga2::commong::object::host
class vision_icinga2::server::object::host () {

  $hosts = $::settings::storeconfigs ? {
    # collect all hosts that have been exported
    true => query_resources(false,
      ['=', 'type', 'Vision_icinga2::Common::Object::Host']
    ),
    default => {}
  }

  each ($hosts) |$host| {
    $host_params = $host['parameters']

    /*
    $overwrite_vars = ($vars['parent'] == undef) ? {
      true    => {},
      default => {
        'remote_client' => $vars['parent'],
      },
    }
    */

    $overwrite_vars = {
      #'remote_client' => $host_params['vars']['parent'],
      'remote_client' => $host['title'],
    }
    $vars = merge($host_params['vars'], $overwrite_vars)

    ::icinga2::object::host { $host['title']:
      ensure                => $host_params['ensure'],
      host_name             => $host_params['host_name'],
      import                => [ 'generic-host' ],
      address               => $host_params['address'],
      address6              => $host_params['address6'],
      vars                  => $vars,
      groups                => $host_params['groups'],
      display_name          => $host_params['display_name'],
      check_command         => $host_params['check_command'],
      max_check_attempts    => $host_params['max_check_attempts'],
      check_period          => $host_params['check_period'],
      check_timeout         => $host_params['check_timeout'],
      check_interval        => $host_params['check_interval'],
      retry_interval        => $host_params['retry_interval'],
      enable_notifications  => $host_params['enable_notifications'],
      enable_active_checks  => $host_params['enable_active_checks'],
      enable_passive_checks => $host_params['enable_passive_checks'],
      enable_event_handler  => $host_params['enable_event_handler'],
      enable_flapping       => $host_params['enable_flapping'],
      enable_perfdata       => $host_params['enable_perfdata'],
      event_command         => $host_params['event_command'],
      flapping_threshold    => $host_params['flapping_threshold'],
      volatile              => $host_params['volatile'],
      zone                  => $host_params['zone'],
      #command_endpoint      => $host['title'],
      notes                 => $host_params['notes'],
      notes_url             => $host_params['notes_url'],
      action_url            => $host_params['action_url'],
      icon_image            => $host_params['icon_image'],
      icon_image_alt        => $host_params['icon_image_alt'],
      template              => $host_params['template'],
      order                 => '50',
      #target                => "${::icinga2::params::conf_dir}/zones.d/${host['title']}/hosts.conf",
      #target                => "${::icinga2::params::conf_dir}/conf.d/hosts.conf",
      #target                => "${::icinga2::params::conf_dir}/zones.d/global-templates/hosts.conf",
      target                => ($vars['parent'] == undef) ? {
        true    => "${::icinga2::params::conf_dir}/zones.d/${host['title']}/hosts.conf",
        default => "${::icinga2::params::conf_dir}/zones.d/${vars['parent']}/hosts.conf",
      },
      require               => ($vars['parent'] == undef) ? {
        true    => undef,
        default => File["${::icinga2::params::conf_dir}/zones.d/${vars['parent']}"],
      }
    }
  }

  /*
  # lint:ignore:variable_scope
  $nodes = $::settings::storeconfigs ? {
    # collect all nodes that have their parent zone configured to be
    # in this servers client zone
    true => query_resources(false,
              ['and',
                ['=', 'type', 'Class'],
                ['=', 'title', 'Vision_icinga2'],
                #['=', ['parameter', 'parent_zone'], $::vision_icinga2::zo]
              ]),
    default => {}
  }

  each ($nodes) |$node| {
    $node_params = $node['parameters']

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

        ::icinga2::object::apply_dependency { "parent-${host['title']}":
          parent_host_name      => $host['title'],
          assign_where          => "host.address && host.vars.parent && host.vars.parent == \"${host['title']}\"",
          disable_notifications => true,
          disable_checks        => true
        }
      }
    }
  }

  # lint:endignore
  */
}
