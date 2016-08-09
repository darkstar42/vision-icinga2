# apply
class vision_icinga2::common::object::apply (
  $notification_group = hiera('icinga2::notification::group', 'vision-sysadmin'),
) {
  ::icinga2::object::apply_notification_to_service { 'sms-service-notification':
    # templates are the new templates. maybe?!
    templates    => ['sms-service-notification'],
    user_groups  => [ $notification_group ],
    assign_where => 'host.vars.notification.pager == true',
  }

  ::icinga2::object::apply_notification_to_host { 'sms-host-notification':
    templates    => ['sms-host-notification'],
    user_groups  => [ $notification_group ],
    assign_where => 'host.vars.notification.pager == true',
  }

  ::icinga2::object::apply_notification_to_service { 'mail-service-notification':
    templates    => ['mail-service-notification'],
    user_groups  => [ $notification_group ],
    assign_where => 'host.vars.notification.email == true',
  }

  ::icinga2::object::apply_notification_to_host { 'mail-host-notification':
    templates    => ['mail-host-notification'],
    user_groups  => [ $notification_group ],
    assign_where => 'host.vars.notification.email == true',
  }

  ::icinga2::object::apply_service { 'ping4':
    check_command    => 'ping4',
    command_endpoint => 'host.vars.parent',
    assign_where     => '"linux-servers" in host.groups',
    ignore_where     => 'host.address == ""',
  }

  ::icinga2::object::apply_service { 'ping6':
    check_command    => 'ping6',
    command_endpoint => 'host.vars.parent',
    assign_where     => '"linux-servers" in host.groups',
    ignore_where     => 'host.address6 == ""',
  }

  ::icinga2::object::apply_service { 'ssh':
    check_command    => 'ssh',
    command_endpoint => 'host.vars.parent',
    assign_where     => 'host.address && "linux-servers" in host.groups',
    ignore_where     => 'host.vars.remote_client == "localhost"',
  }
  #  Broken, see https://vision.fraunhofer.de/redmine/issues/273
  #  ::icinga2::object::apply_service { 'http-proc':
  #    check_command => 'proc',
  #    assign_where  => 'host.address && "linux-servers" in host.groups',
  #    ignore_where  => 'host.vars.remote_client == "localhost"',
  #  }
  ::icinga2::object::apply_service { 'http':
    display_name  => 'http',
    apply         => 'for (identifier   => config in host.vars.services.http)',
    check_command => 'http',
    vars          => {
      http_vhost   => '$host.address$',
      http_address => '$host.address$',
      http_uri     => 'config.http_uri',
    },
    custom_append => [
      'vars += config',
    ],
  }

  ::icinga2::object::apply_service { 'gitlab_status':
    display_name  => 'GitLab',
    check_command => 'gitlab_status',
    vars          => {
      gitlab_health_url => '$host.vars.services.gitlab.health_check_url$',
    },
    assign_where  => 'host.vars.services.gitlab',
  }

  ::icinga2::object::apply_service { 'smart_status':
    apply         => 'for (identifier => disk in host.vars.disks)',
    check_command => 'smart_status',
    custom_append => [
      'vars += { disk = "/dev/" + identifier }',
    ],
    assign_where  => 'host.vars.disks',
  }

  # using for loops is currently impossible to use with the puppet module:
  # https://dev.icinga.org/issues/10804
  # and icinga
  ::icinga2::object::apply_service { 'backupage':
    templates     => ['onceaday-service'],
    display_name  => 'Backupage',
    apply         => 'for (identifier => backup in host.vars.services.backup)',
    check_command => 'vision-backupage',
    custom_append => [
      'vars += backup',
    ],
  }
  ::icinga2::object::apply_service { 'mysql':
    display_name  => 'mysql',
    check_command => 'mysql',
    vars          => {
      mysql_hostname => '$host.address$',
      mysql_username => '$host.vars.services.mysql.username$',
      mysql_password => '$host.vars.services.mysql.password$',
    },
    assign_where  => 'host.vars.services.mysql',
  }
  ::icinga2::object::apply_service { 'disk':
    check_command    => 'disk',
    command_endpoint => 'host.vars.remote_client',
    assign_where     => '"linux-servers" in host.groups',
  }

  ::icinga2::object::apply_service { 'exim':
    check_command    => 'vision-mailq',
    command_endpoint => 'host.vars.remote_client',
    assign_where     => '"linux-servers" in host.groups',
  }

  ::icinga2::object::apply_service { 'apt':
    check_command        => 'apt',
    command_endpoint     => 'host.vars.remote_client',
    assign_where         => 'host.vars.distro == "Debian"',
    enable_notifications => false,
  }
  ::icinga2::object::apply_service { 'reboot_required':
    check_command        => 'reboot_required',
    command_endpoint     => 'host.vars.remote_client',
    assign_where         => 'host.vars.distro == "Debian"',
    enable_notifications => false,
  }

  ::icinga2::object::apply_service { 'load':
    check_command    => 'load',
    command_endpoint => 'host.vars.remote_client',
    assign_where     => '"linux-servers" in host.groups',
  }

  ::icinga2::object::apply_service { 'procs':
    check_command    => 'procs',
    command_endpoint => 'host.vars.remote_client',
    assign_where     => '"linux-servers" in host.groups',
  }
  ::icinga2::object::apply_service { 'users':
    check_command    => 'users',
    command_endpoint => 'host.vars.remote_client',
    assign_where     => '"linux-servers" in host.groups',
  }

  ::icinga2::object::apply_service { 'icinga':
    check_command    => 'icinga',
    command_endpoint => 'host.vars.remote_client',
    assign_where     => 'host.vars.services.icinga_server',
  }
}
