# checkcommand
class vision_icinga2::common::object::checkcommand (
  String $path = hiera('vision::monitoring::checks', '/vision/monitoring-checks'),
) {

  contain ::vision_monitoring

  # Puppet needs to write quoted strings into the file
  # therefore manually escape quotes
  $vision_cmd_path = "${path}"

  ::icinga2::object::checkcommand { 'vision-mysql':
    import    => [ 'plugin-check-command' ],
    command   => [ '/check_mysql' ],
    arguments => {
      '-d' => '$mysql_database$',
      '-u' => '$mysql_user$',
      '-p' => '$mysql_password$',
    },
    vars      => {
      'mysql_user' => 'monitoring',
    },
    target    => "${::icinga2::params::conf_dir}/zones.d/global-templates/checkcommands.conf",
  }

  ::icinga2::object::checkcommand { 'vision-mailq':
    import    => [ 'plugin-check-command' ],
    command   => [ '/check_mailq' ],
    arguments => {
      '-w' => '$mailq_warning$',
      '-c' => '$mailq_critical$',
      '-M' => '$mailq_mailserver$',
    } ,
    vars      => {
      'mailq_warning'    => '3',
      'mailq_critical'   => '5',
      'mailq_mailserver' => 'exim',
    },
    target    => "${::icinga2::params::conf_dir}/zones.d/global-templates/checkcommands.conf",
  }

  ::icinga2::object::checkcommand { 'vision-backupage':
    command   => [ "${vision_cmd_path}/check_backupage" ],
    arguments => {
      '--pseudo' => {
        # ignorieren des 'keys', es wird also kein switch verwendet
        skip_key => true,
        value    => '$backupage_location$',
      }
    },
    target    => "${::icinga2::params::conf_dir}/zones.d/global-templates/checkcommands.conf",
  }

  # check if reboot is required
  ::icinga2::object::checkcommand { 'reboot_required':
    command   => [ "${vision_cmd_path}/check_reboot_required" ],
    target    => "${::icinga2::params::conf_dir}/zones.d/global-templates/checkcommands.conf",
  }

  # monitor gitlab status
  ::icinga2::object::checkcommand { 'gitlab_status':
    command   => [ "${vision_cmd_path}/check_gitlab_status" ],
    arguments => {
      '--pseudo' => {
        # ignorieren des 'keys', es wird also kein switch verwendet
        skip_key => true,
        value    => '$gitlab_health_url$',
      }
    },
    target    => "${::icinga2::params::conf_dir}/zones.d/global-templates/checkcommands.conf",
  }

  # monitor SMART status
  ::icinga2::object::checkcommand { 'smart_status':
    command   => [ '/usr/bin/sudo /usr/lib/nagios/plugins/check_scsi_smart' ],
    arguments => {
      '-d' => {
        value => '$disk$',
      }
    },
    target    => "${::icinga2::params::conf_dir}/zones.d/global-templates/checkcommands.conf",
  }

  # monitor Puppet agent
  ::icinga2::object::checkcommand { 'puppet_agent':
    command   => [ '/check_puppet_agent' ],
    arguments => {
      '-w' => {
        value => '86400', # 24h * 60min * 60sec
      },
      '-c' => {
        value => '172800', # 2 * 24h * 60min * 60sec
      },
    },
    target    => "${::icinga2::params::conf_dir}/zones.d/global-templates/checkcommands.conf",
  }
}
