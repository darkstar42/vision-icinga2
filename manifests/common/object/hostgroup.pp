# documentation
class vision_icinga2::common::object::hostgroup {
  ::icinga2::object::hostgroup { 'linux-servers':
    display_name => 'Linux Servers',
    assign       => [
      'host.vars.os == Linux',
    ],
    target       => "${::icinga2::params::conf_dir}/conf.d/hostgroups.conf"
  }

  ::icinga2::object::hostgroup { 'virtual-machines':
    display_name => 'Virtual Machines',
    assign       => [
      'host.vars.vm',
    ],
    target       => "${::icinga2::params::conf_dir}/conf.d/hostgroups.conf"
  }

  ::icinga2::object::hostgroup { 'web-servers':
    display_name => 'Web Servers',
    assign       => [
      'typeof(host.vars.services.http) == Dictionary',
    ],
    target       => "${::icinga2::params::conf_dir}/conf.d/hostgroups.conf"
  }
}
