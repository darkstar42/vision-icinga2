# = Class: vision_icinga2::common::object::servicegroup

class vision_icinga2::common::object::servicegroup {
  ::icinga2::object::servicegroup { 'ping':
    display_name => 'Ping checks',
    assign_where => 'match("ping*", service.check_command)',
  }

  ::icinga2::object::servicegroup { 'http':
    display_name => 'HTTP checks',
    assign_where => 'match("http_*", service.check_command)',
  }

  ::icinga2::object::servicegroup { 'disk':
    display_name => 'Disk checks',
    assign_where => 'service.check_command == "disk"',
  }

  ::icinga2::object::servicegroup { 'mysql':
    # not sure why we would ref. the target dir here
    #
    # target_dir   => $::target_dir,
    assign_where => 'match("mysql_*", service.check_command)',
  }
}
