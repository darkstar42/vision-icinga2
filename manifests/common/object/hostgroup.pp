# documentation
class vision_icinga2::common::object::hostgroup {
  ::icinga2::object::hostgroup { 'linux-servers':
    display_name => 'Linux Servers',
    assign_where => 'host.vars.os == "Linux"',
  }

  ::icinga2::object::hostgroup { 'virtual-machines':
    display_name => 'Virtual Machines',
    assign_where => 'host.vars.vm',
  }

  ::icinga2::object::hostgroup { 'web-servers':
    display_name => 'Web Servers',
    assign_where => 'typeof(host.vars.services.http) == Dictionary',
  }
}
