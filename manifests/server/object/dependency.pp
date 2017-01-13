# documentation
class vision_icinga2::server::object::dependency {

  $hosts = $::settings::storeconfigs ? {
    # collect all hosts that have been exported
    true => query_resources(false,
      ['=', 'type', 'Vision_icinga2::Common::Object::Host']
    ),
    default => {}
  }

  each ($hosts) |$host| {
    $host_params = $host['parameters']
    $vars = $host_params['vars']

    if $vars['parent'] != undef {
      ::icinga2::object::dependency { "parent-${host['title']}":
        parent_host_name      => $vars['parent'],
        child_host_name       => $host['title'],
        disable_notifications => true,
        disable_checks        => true,
        ignore_soft_states    => true,
        #target                => "${::icinga2::params::conf_dir}/zones.d/${vars['parent']}/dependencies.conf",
        target                => "${::icinga2::params::conf_dir}/conf.d/dependencies.conf",
      }
    }
  }
}
