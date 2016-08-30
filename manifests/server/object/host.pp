# = Class: vision_icinga2::server::object::host
#
# == Parameters:
  #
  # [*zone*]
  #
  # Default: $::fqdn

class vision_icinga2::server::object::host (
  $zone = hiera('icinga2::client::zone', $::fqdn),
) {
  # lint:ignore:variable_scope
  $child_nodes = $::settings::storeconfigs ? {
    true => query_resources(false,
              ['and',
                ['=', 'type', 'Class'],
                ['=', 'title', 'vision_icinga2::Base::Monitoring'],
                ['=', ['parameter', 'parent_zone'], $zone]]),
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
      # dir01.prd.dmz -> visionx1/visionx2 -> vision07
      # the query asks for all client parameters, which are search for its
      # parent_zone.
      $endpoint = query_resources(false,
        ['and',
          ['=', 'type', 'Class'],
          ['=', 'title', 'vision_icinga2::Base::Monitoring'],
          ['=', 'certname', $host['title']]
        ]
      );

      $overwrite_vars = {
        'remote_client' => $child_node['certname'],
      }
      $vars = merge($host_params['vars'], $overwrite_vars)

      ::icinga2::object::host { $host['title']:
        display_name     => $host_params['display_name'],
        ipv4_address     => $host_params['ipv4_address'],
        vars             => $vars,
        target_file_name => $host_params['target_file_name'],
        command_endpoint => $endpoint[0]['parameters']['parent_zone'],
      }
    }
  }

  # lint:endignore
}
