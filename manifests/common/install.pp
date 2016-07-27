# Class: vision_icinga2::common::install
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_icinga2
#

class vision_icinga2::common::install (

) {
  contain ::vision_icinga2::common::user

  $plugin_packages = [
    'nagios-plugins',
    'nagios-plugins-basic',
    'nagios-plugins-standard',
    'nagios-snmp-plugins',
    'nagios-plugins-contrib',
  ]
  $mail_package = 'mailutils'

  ::apt::source { 'debmon':
    location    => 'http://debmon.org/debmon',
    release     => "debmon-${::lsbdistcodename}",
    repos       => 'main',
    key         => '7E55BD75930BB3674BFD6582DC0EE15A29D662D2',
    key_source  => 'http://debmon.org/debmon/repo.key',
    include_src => false
  }

  exec { 'icinga2-apt-update':
    command => '/usr/bin/apt-get update',
    require => ::Apt::Source['debmon']
  }

  package { $plugin_packages:
    ensure  => present,
    require => Exec['icinga2-apt-update']
  }

  package { $mail_package:
    ensure  => present,
    require => Exec['icinga2-apt-update']
  }
}
