# not empty
class vision_icinga2::server::object::notification (
  String $notification_group = hiera('icinga2::notification::group', 'vision-sysadmin'),
) {
  ::icinga2::object::apply_notification_to_service { 'mail-service':
    assign_where => 'true == true',
    command      => 'mail-service-notification',
    user_groups  => [ $notification_group ],
    states       => [ 'OK', 'Warning', 'Critical', 'Unknown' ],
    types        => [ 'Problem', 'Acknowledgement', 'Recovery', 'Custom' ],
    period       => '24x7',
  }

  ::icinga2::object::apply_notification_to_service { 'slack-service':
    assign_where => 'true == true',
    command      => 'slack-service-notification',
    users        => [ 'vision-it' ],
    states       => [ 'OK', 'Warning', 'Critical', 'Unknown' ],
    types        => [ 'Problem', 'Acknowledgement', 'Recovery', 'Custom' ],
    period       => '24x7',
  }
}
