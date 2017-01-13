# = Class: vision_icinga2::server::object::usergroup
class vision_icinga2::server::object::usergroup () {
  ::icinga2::object::usergroup { $::vision_icinga2::server::notification_group:
    target => "${::icinga2::params::conf_dir}/conf.d/usergroups.conf"
  }
}
