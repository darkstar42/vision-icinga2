# notificationcommand profile
class vision_icinga2::server::object::notificationcommand (
  String $notification_slack_icinga_host = $::vision_icinga2::server::notification_slack_icinga_host,
  String $notification_slack_webhook_url = $::vision_icinga2::server::notification_slack_webhook_url,
  String $notification_slack_channel = $::vision_icinga2::server::notification_slack_channel,
  String $notification_slack_bot_name = $::vision_icinga2::server::notification_slack_bot_name,
) {
  ::icinga2::object::notificationcommand { 'sms-service-notification':
    command  => [ '/icinga2/scripts/sms-service-notification.sh' ],
    cmd_path => 'SysconfDir',
    env      => {
      'NOTIFICATIONTYPE' => '"$notification.type$"',
      'SERVICEDESC'      => '"$service.name$"',
      'HOSTALIAS'        => '"$host.display_name$"',
      'SERVICESTATE'     => '"$service.state$"',
      'DATETIME'         => '"$icinga.short_date_time$"',
      'SERVICEOUTPUT'    => '"$service.output$"',
      'USERPAGER'        => '"$user.pager$"',
    },
  }

  ::icinga2::object::notificationcommand { 'sms-host-notification':
    command  => [ '/icinga2/scripts/sms-host-notification.sh' ],
    cmd_path => 'SysconfDir',
    env      => {
      'NOTIFICATIONTYPE' => '"$notification.type$"',
      'HOSTALIAS'        => '"$host.display_name$"',
      'HOSTSTATE'        => '"$host.state$"',
      'DATETIME'         => '"$icinga.short_date_time$"',
      'HOSTOUTPUT'       => '"$host.output$"',
      'USERPAGER'        => '"$user.pager$"',
    },
  }

  ::icinga2::object::notificationcommand { 'mail-service-notification':
    command  => [ '/icinga2/scripts/mail-service-notification.sh' ],
    cmd_path => 'SysconfDir',
    env      => {
      'NOTIFICATIONTYPE'       => '"$notification.type$"',
      'SERVICEDESC'            => '"$service.name$"',
      'HOSTALIAS'              => '"$host.display_name$"',
      'HOSTADDDRESS'           => '"$address$"',
      'SERVICESTATE'           => '"$service.state$"',
      'LONGDATETIME'           => '"$icinga.long_date_time$"',
      'SERVICEOUTPUT'          => '"$service.output$"',
      'NOTIFICATIONAUTHORNAME' => '"$notification.author$"',
      'NOTIFICATIONCOMMENT'    => '"$notification.comment$"',
      'HOSTDISPLAYNAME'        => '"$service.display_name$"',
      'USEREMAIL'              => '"$user.email$"',
    },
  }

  ::icinga2::object::notificationcommand { 'mail-host-notification':
    command  => [ '/icinga2/scripts/mail-host-notification.sh' ],
    cmd_path => 'SysconfDir',
    env      => {
      'NOTIFICATIONTYPE'       => '"$notification.type$"',
      'HOSTALIAS'              => '"$host.display_name$"',
      'HOSTADDRESS'            => '"$address$"',
      'HOSTSTATE'              => '"$host.state$"',
      'LONGDATETIME'           => '"$icinga.long_date_time$"',
      'HOSTOUTPUT'             => '"$host.output$"',
      'NOTIFICATIONAUTHORNAME' => '"$notification.author$"',
      'NOTIFICATIONCOMMENT'    => '"$notification.comment$"',
      'HOSTDISPLAYNAME'        => '"$host.display_name$"',
      'USEREMAIL'              => '"$user.email$"',
    },
  }

  file { '/etc/icinga2/scripts/slack-service-notification.sh':
    mode    => '0755',
    content => template('vision_icinga2/notifications/slack-service-notification.sh.erb'),
  }

  ::icinga2::object::notificationcommand { 'slack-service-notification':
    command  => [ '/icinga2/scripts/slack-service-notification.sh' ],
    cmd_path => 'SysconfDir',
    env      => {
      'NOTIFICATIONTYPE'       => '"$notification.type$"',
      'SERVICEDESC'            => '"$service.name$"',
      'HOSTALIAS'              => '"$host.display_name$"',
      'HOSTNAME'               => '"$host.name$"',
      'HOSTADDRESS'            => '"$address$"',
      'SERVICESTATE'           => '"$service.state$"',
      'LONGDATETIME'           => '"$icinga.long_date_time$"',
      'SERVICEOUTPUT'          => '"$service.output$"',
      'NOTIFICATIONAUTHORNAME' => '"$notification.author$"',
      'NOTIFICATIONCOMMENT'    => '"$notification.comment$"',
      'HOSTDISPLAYNAME'        => '"$host.display_name$"',
      'SERVICEDISPLAYNAME'     => '"$service.display_name$"',
    },
  }
}
