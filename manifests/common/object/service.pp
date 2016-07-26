# creates new service templates
class vision_icinga2::common::object::service() {
  ::icinga2::object::service { 'onceaday-service':
    is_template    => true,
    check_interval => '24h',
  }
}
