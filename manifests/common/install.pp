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
# contain ::vision_icinga2::common::install
#

class vision_icinga2::common::install {

  contain ::vision_groups

  $plugin_packages = [
    'nagios-plugins',
    'nagios-plugins-basic',
    'nagios-plugins-standard',
    'nagios-snmp-plugins',
    'nagios-plugins-contrib',
  ]
  $mail_package = 'mailutils'

  $plugin_packages.each |$idx, $pkg| {
    if !defined(Package[$pkg]) {
      package { $pkg:
        ensure  => present,
        #require => Exec['icinga2-apt-update']
      }
    }
  }

  package { $mail_package:
    ensure  => present,
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

  class { '::icinga2':
    manage_repo => true,
    features    => [],
    plugins     => [
      'plugins',
      'plugins-contrib',
    ],
    constants   => {
      'ZoneName' => $::vision_icinga2::zone,
    }
  }

  file { "${::icinga2::params::conf_dir}/zones.d":
    ensure  => directory,
    owner   => nagios,
    group   => nagios,
    recurse => true,
    purge   => true,
    require => File[$::icinga2::params::conf_dir],
  }
}
