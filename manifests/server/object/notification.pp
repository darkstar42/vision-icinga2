# not empty
class vision_icinga2::server::object::notification () {
  ::icinga2::object::apply_notification_to_service { 'mail-service':
    assign_where => 'true == true',
    command      => 'mail-service-notification',
    user_groups  => [ $::vision_icinga2::server::notification_group ],
    states       => [ 'OK', 'Warning', 'Critical' ],
    types        => [ 'Problem', 'Acknowledgement', 'Recovery', 'Custom' ],
    period       => '24x7',
  }

  ::icinga2::object::apply_notification_to_service { 'slack-service':
    assign_where => 'true == true',
    command      => 'slack-service-notification',
    users        => [ 'vision-it' ],
    states       => [ 'OK', 'Warning', 'Critical' ],
    types        => [ 'Problem', 'Acknowledgement', 'Recovery', 'Custom' ],
    period       => '24x7',
  }
}
