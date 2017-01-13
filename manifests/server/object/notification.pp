# not empty
class vision_icinga2::server::object::notification (
  $notification_group = hiera('icinga2::notification::group', 'vision-sysadmin'),
) {
  ::icinga2::object::notification { 'apply-sms-service-notification':
    import       => [ 'sms-service-notification' ],
    apply        => true,
    apply_target => 'Service',
    user_groups  => [ $notification_group ],
    assign       => [
      'host.vars.notification.pager == true',
    ],
    target       => "${::icinga2::params::conf_dir}/conf.d/notifications.conf",
  }

  ::icinga2::object::notification { 'apply-sms-host-notification':
    import       => [ 'sms-host-notification' ],
    apply        => true,
    apply_target => 'Host',
    user_groups  => [ $notification_group ],
    assign       => [
      'host.vars.notification.pager == true',
    ],
    target       => "${::icinga2::params::conf_dir}/conf.d/notifications.conf",
  }

  ::icinga2::object::notification { 'apply-mail-service-notification':
    import       => [ 'mail-service-notification' ],
    apply        => true,
    apply_target => 'Service',
    user_groups  => [ $notification_group ],
    assign       => [
      'host.vars.notification.email == true',
    ],
    target       => "${::icinga2::params::conf_dir}/conf.d/notifications.conf",
  }

  ::icinga2::object::notification { 'apply-mail-host-notification':
    import       => [ 'mail-host-notification' ],
    apply        => true,
    apply_target => 'Host',
    user_groups  => [ $notification_group ],
    assign       => [
      'host.vars.notification.email == true',
    ],
    target       => "${::icinga2::params::conf_dir}/conf.d/notifications.conf",
  }

  ::icinga2::object::notification { 'mail-service':
    apply        => true,
    apply_target => 'Service',
    assign       => [
      'true == true',
    ],
    command      => 'mail-service-notification',
    user_groups  => [ $::vision_icinga2::server::notification_group ],
    states       => [ 'OK', 'Warning', 'Critical' ],
    types        => [ 'Problem', 'Acknowledgement', 'Recovery', 'Custom' ],
    period       => '24x7',
    target       => "${::icinga2::params::conf_dir}/conf.d/notifications.conf"
  }

  ::icinga2::object::notification { 'slack-service':
    apply        => true,
    apply_target => 'Service',
    assign       => [
      'true == true',
    ],
    command      => 'slack-service-notification',
    users        => [ 'vision-it' ],
    states       => [ 'OK', 'Warning', 'Critical' ],
    types        => [ 'Problem', 'Acknowledgement', 'Recovery', 'Custom' ],
    period       => '24x7',
    target       => "${::icinga2::params::conf_dir}/conf.d/notifications.conf"
  }
}
