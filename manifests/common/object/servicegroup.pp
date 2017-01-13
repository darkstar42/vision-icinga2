# = Class: vision_icinga2::common::object::servicegroup

class vision_icinga2::common::object::servicegroup {
  ::icinga2::object::servicegroup { 'ping':
    display_name => 'Ping checks',
    assign       => [
      'match(ping*, service.check_command)',
    ],
    target       => "${::icinga2::params::conf_dir}/conf.d/servicegroups.conf"
  }

  ::icinga2::object::servicegroup { 'http':
    display_name => 'HTTP checks',
    assign       => [
      'match(http_*, service.check_command)',
    ],
    target       => "${::icinga2::params::conf_dir}/conf.d/servicegroups.conf"
  }

  ::icinga2::object::servicegroup { 'disk':
    display_name => 'Disk checks',
    assign       => [
      'service.check_command == disk',
    ],
    target       => "${::icinga2::params::conf_dir}/conf.d/servicegroups.conf"
  }

  ::icinga2::object::servicegroup { 'mysql':
    display_name => 'MySQL checks',
    assign       => [
      'match(mysql_*, service.check_command)',
    ],
    target       => "${::icinga2::params::conf_dir}/conf.d/servicegroups.conf"
  }
}
