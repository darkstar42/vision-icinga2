# checkcommand
class vision_icinga2::common::object::checkcommand (
  String $path = hiera('vision::monitoring::checks', '/vision/monitoring-checks'),
  ) {

  contain ::vision_monitoring

  # Puppet needs to write quoted strings into the file
  # therefore manually escape quotes
  $vision_cmd_path = "\"${path}\""

  ::icinga2::object::checkcommand { 'vision-mysql':
    templates => ['plugin-check-command'],
    command   => ['/check_mysql'],
    arguments => {
      '"-d"' => '"$mysql_database$"',
      '"-u"' => '"$mysql_user$"',
      '"-p"' => '"$mysql_password$"',
    },
    vars      => {
      'mysql_user' => '"monitoring"',
    },
  }

  ::icinga2::object::checkcommand { 'vision-mailq':
    templates => ['plugin-check-command'],
    command   => ['/check_mailq'],
    arguments => {
      '"-w"' => '"$mailq_warning$"',
      '"-c"' => '"$mailq_critical$"',
      '"-M"' => '"$mailq_mailserver$"',
    } ,
    vars      => {
      'mailq_warning'    => '3',
      'mailq_critical'   => '5',
      'mailq_mailserver' => '"exim"',
    },
  }

  ::icinga2::object::checkcommand { 'vision-backupage':
    command   => ['/check_backupage'],
    arguments => {
      '"--pseudo"' => {
        # ignorieren des 'keys', es wird also kein switch verwendet
        skip_key => true,
        value    => '"$backupage_location$"',
      }
    },
    cmd_path  => $vision_cmd_path,
  }

  # check if reboot is required
  ::icinga2::object::checkcommand { 'reboot_required':
    command  => ['/check_reboot_required'],
    cmd_path => $vision_cmd_path,
  }

  # monitor gitlab status
  ::icinga2::object::checkcommand { 'gitlab_status':
    command   => ['/check_gitlab_status'],
    arguments => {
      '"--pseudo"' => {
        # ignorieren des 'keys', es wird also kein switch verwendet
        skip_key => true,
        value    => '"$gitlab_health_url$"',
      }
    },
    cmd_path  => $vision_cmd_path,
  }

  # monitor SMART status
  ::icinga2::object::checkcommand { 'smart_status':
    command   => ['/usr/bin/sudo /usr/lib/nagios/plugins/check_scsi_smart'],
    arguments => {
      '"-d"' => {
        value => '"$disk$"',
      }
    },
  }

  # monitor Puppet agent
  ::icinga2::object::checkcommand { 'puppet_agent':
    command   => ['/check_puppet_agent'],
    arguments => {
      '"-w"' => {
        value => '"86400"', # 24h * 60min * 60sec
      },
      '"-c"' => {
        value => '"172800"', # 2 * 24h * 60min * 60sec
      },
    }
  }
}
