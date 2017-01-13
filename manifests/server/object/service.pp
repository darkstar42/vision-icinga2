# creates new service templates
class vision_icinga2::server::object::service() {
  ::icinga2::object::service { 'onceaday-service':
    template       => true,
    check_interval => '24h',
    target         => "${::icinga2::params::conf_dir}/conf.d/services.conf"
  }
}
