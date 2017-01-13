# = Class: vision_icinga2::common::object::template

class vision_icinga2::common::object::template {
  ::icinga2::object::host { 'generic-host':
    template           => true,
    check_command      => 'hostalive',
    max_check_attempts => 3,
    check_interval     => '3m',
    retry_interval     => '1m',
    target             => "${::icinga2::params::conf_dir}/conf.d/templates.conf",
  }

  ::icinga2::object::service { 'generic-service':
    template           => true,
    max_check_attempts => 5,
    check_interval     => '3m',
    retry_interval     => '1m',
    target             => "${::icinga2::params::conf_dir}/conf.d/templates.conf",
  }

  ::icinga2::object::user { 'generic-user':
    template => true,
    target   => "${::icinga2::params::conf_dir}/conf.d/templates.conf",
  }

  ::icinga2::object::notification { 'mail-host-notification':
    template => true,
    command  => 'mail-host-notification',
    states   => [
      'Up',
      'Down',
    ],
    types    => [
      'Problem',
      'Acknowledgment',
      'Recovery',
      'Custom',
      'DowntimeStart',
      'DowntimeEnd',
      'DowntimeRemoved',
    ],
    period   => '24x7',
    target   => "${::icinga2::params::conf_dir}/conf.d/templates.conf",
  }

  ::icinga2::object::notification { 'mail-service-notification':
    template => true,
    command  => 'mail-service-notification',
    states   => [
      'OK',
      'Warning',
      'Critical',
      'Unknown',
    ],
    types    => [
      'Problem',
      'Acknowledgment',
      'Recovery',
      'Custom',
      'DowntimeStart',
      'DowntimeEnd',
      'DowntimeRemoved',
    ],
    period   => '24x7',
    target   => "${::icinga2::params::conf_dir}/conf.d/templates.conf",
  }

  ::icinga2::object::notification { 'sms-host-notification':
    template => true,
    command  => 'sms-host-notification',
    states   => [
      'Up',
      'Down',
    ],
    types    => [
      'Problem',
      'Acknowledgment',
      'Recovery',
      'Custom',
      'DowntimeStart',
      'DowntimeEnd',
      'DowntimeRemoved',
    ],
    period   => '24x7',
    interval => '10',
    target   => "${::icinga2::params::conf_dir}/conf.d/templates.conf",
  }

  ::icinga2::object::notification { 'sms-service-notification':
    template => true,
    command  => 'sms-service-notification',
    states   => [
      'OK',
      'Warning',
      'Critical',
      'Unknown',
    ],
    types    => [
      'Problem',
      'Acknowledgment',
      'Recovery',
      'Custom',
      'DowntimeStart',
      'DowntimeEnd',
      'DowntimeRemoved',
    ],
    period   => '24x7',
    interval => '10',
    target   => "${::icinga2::params::conf_dir}/conf.d/templates.conf",
  }

  /*
  ::icinga2::object::scheduleddowntime { 'backup-downtime':
    author             => 'icingaadmin',
    comment            => 'Scheduled downtime for backup',
    ranges             => {
      'monday'    => '02:00-03:00',
      'tuesday'   => '02:00-03:00',
      'wednesday' => '02:00-03:00',
      'thursday'  => '02:00-03:00',
      'friday'    => '02:00-03:00',
      'saturday'  => '02:00-03:00',
      'sunday'    => '02:00-03:00',
    },
    target             => "${::icinga2::params::conf_dir}/conf.d/templates.conf",
  }
  */
}
