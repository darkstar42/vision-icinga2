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
  contain ::vision_groups

  $plugin_packages = [
    'nagios-plugins',
    'nagios-plugins-basic',
    'nagios-plugins-standard',
    'nagios-snmp-plugins',
    'nagios-plugins-contrib',
  ]
  $mail_packages = ['mailutils']

  package { union($plugin_packages, $mail_packages):
    ensure  => present,
  }

  class { '::icinga2':
    db_type          => 'none',
    use_debmon_repo  => false,
    manage_repos     => false,
    purge_configs    => true,
    purge_confd      => true,
    default_features => false,
    require          => Package[$plugin_packages]
  }

  user { ['icinga', 'nagios']:
    ensure  => present,
    groups  => [
      'monitor',
      'ssl-cert',
      'Debian-exim',
      'storage'
    ],
    require => [
      Group['monitor'],
      Group['ssl-cert'],
      Group['Debian-exim'],
      Group['storage']
    ]
  }

}
