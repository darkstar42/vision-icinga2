# apply
class vision_icinga2::common::object::apply {

  ::icinga2::object::service { 'icinga':
    apply            => true,
    import           => [ 'generic-service' ],
    check_command    => 'icinga',
    command_endpoint => 'host.vars.remote_client',
    assign           => [
      'host.vars.remote_client',
    ],
    target           => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  ::icinga2::object::service { 'ping4':
    apply            => true,
    import           => [ 'generic-service' ],
    check_command    => 'ping4',
    assign           => [
      'host.address',
    ],
    target           => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  ::icinga2::object::service { 'ping6':
    apply            => true,
    import           => [ 'generic-service' ],
    check_command    => 'ping6',
    assign           => [
      'host.address6',
    ],
    target           => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  ::icinga2::object::service { 'ssh':
    apply            => true,
    import           => [ 'generic-service' ],
    check_command    => 'ssh',
    assign           => [
      '(host.address || host.address6) && linux-servers in host.groups',
    ],
    target           => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  #  Broken, see https://vision.fraunhofer.de/redmine/issues/273
  #  ::icinga2::object::apply_service { 'http-proc':
  #    check_command => 'proc',
  #    assign_where  => 'host.address && linux-servers in host.groups',
  #    ignore_where  => 'host.vars.remote_client == "localhost"',
  #  }

  ::icinga2::object::service { 'http':
    import           => [ 'generic-service' ],
    apply            => 'identifier => config in host.vars.services.http',
    display_name     => 'http',
    check_command    => 'http',
    vars             => {
      http_vhost   => '$host.address$',
      http_address => '$host.address$',
      #http_uri     => 'function () { return config.http_uri }',
    },
    target           => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
    /*
    custom_append => [
      'vars += config',
    ],
    */
  }

  ::icinga2::object::service { 'gitlab_status':
    apply            => true,
    import           => [ 'generic-service' ],
    display_name     => 'GitLab',
    check_command    => 'gitlab_status',
    vars             => {
      gitlab_health_url => '$host.vars.services.gitlab.health_check_url$',
    },
    assign           => [
      'host.vars.services.gitlab',
    ],
    target           => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  ::icinga2::object::service { 'smart_status':
    apply         => 'identifier => disk in host.vars.disks',
    import        => [ 'generic-service' ],
    check_command => 'smart_status',
    assign        => [
      'host.vars.disks',
    ],
    /*
    custom_append => [
      'vars += { disk = "/dev/" + identifier }',
    ],
    */
    target        => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  # using for loops is currently impossible to use with the puppet module:
  # https://dev.icinga.org/issues/10804
  # and icinga
  ::icinga2::object::service { 'backupage':
    apply         => 'identifier => backup in host.vars.services.backup',
    import        => [ 'generic-service', 'onceaday-service' ],
    display_name  => 'Backupage',
    check_command => 'vision-backupage',
    /*
    custom_append => [
      'vars += backup',
    ],
    */
    target        => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }
  ::icinga2::object::service { 'mysql':
    apply         => true,
    import        => [ 'generic-service' ],
    check_command => 'mysql',
    vars          => {
      mysql_hostname => '$host.address$',
      mysql_username => '$host.vars.services.mysql.username$',
      mysql_password => '$host.vars.services.mysql.password$',
    },
    assign        => [
      'host.vars.services.mysql',
    ],
    target        => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  ::icinga2::object::service { 'disk':
    apply            => true,
    import           => [ 'generic-service' ],
    check_command    => 'disk',
    command_endpoint => 'host.vars.remote_client',
    assign           => [
      'host.vars.remote_client && linux-servers in host.groups',
    ],
    target           => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  ::icinga2::object::service { 'exim':
    apply            => true,
    import           => [ 'generic-service' ],
    check_command    => 'vision-mailq',
    command_endpoint => 'host.vars.remote_client',
    assign           => [
      'host.vars.remote_client && linux-servers in host.groups',
    ],
    target           => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  ::icinga2::object::service { 'apt':
    apply                => true,
    import               => [ 'generic-service' ],
    check_command        => 'apt',
    command_endpoint     => 'host.vars.remote_client',
    assign               => [
      'host.vars.remote_client && host.vars.distro == Debian',
    ],
    enable_notifications => false,
    target               => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  ::icinga2::object::service { 'reboot_required':
    apply                => true,
    import               => [ 'generic-service' ],
    check_command        => 'reboot_required',
    command_endpoint     => 'host.vars.remote_client',
    assign               => [
      'host.vars.remote_client && host.vars.distro == Debian',
    ],
    enable_notifications => false,
    target               => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  ::icinga2::object::service { 'load':
    apply            => true,
    import           => [ 'generic-service' ],
    check_command    => 'load',
    command_endpoint => 'host.vars.remote_client',
    assign           => [
      'host.vars.remote_client && linux-servers in host.groups',
    ],
    vars             => {
      load_wload1  => '$host.vars.services.load.wload1$',
      load_wload5  => '$host.vars.services.load.wload5$',
      load_wload15 => '$host.vars.services.load.wload15$',
      load_cload1  => '$host.vars.services.load.cload1$',
      load_cload5  => '$host.vars.services.load.cload5$',
      load_cload15 => '$host.vars.services.load.cload15$',
    },
    target           => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  ::icinga2::object::service { 'procs':
    apply            => true,
    import           => [ 'generic-service' ],
    check_command    => 'procs',
    command_endpoint => 'host.vars.remote_client',
    assign           => [
      'host.vars.remote_client && linux-servers in host.groups',
    ],
    vars             => {
      procs_warning  => '$host.vars.services.procs.warning$',
      procs_critical => '$host.vars.services.procs.critical$'
    },
    target           => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  ::icinga2::object::service { 'users':
    apply            => true,
    import           => [ 'generic-service' ],
    check_command    => 'users',
    command_endpoint => 'host.vars.remote_client',
    assign           => [
      'host.vars.remote_client && linux-servers in host.groups',
    ],
    vars             => {
      users_wgreater => '$host.vars.services.users.warning$',
      users_cgreater => '$host.vars.services.users.critical$'
    },
    target           => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }

  ::icinga2::object::service { 'puppet_agent':
    apply            => true,
    import           => [ 'generic-service' ],
    check_command    => 'puppet_agent',
    command_endpoint => 'host.vars.remote_client',
    assign           => [
      'host.vars.remote_client && host.vars.distro == Debian',
    ],
    target           => "${::icinga2::params::conf_dir}/conf.d/applies.conf",
  }
}
