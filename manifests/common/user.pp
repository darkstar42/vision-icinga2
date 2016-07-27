class vision_icinga2::common::user {
  group { 'nagios':
    ensure => present,
  }

  user { 'nagios':
    ensure  => present,
    groups  => [
      'nagios',
      'ssl-cert',
    ],
    require => [
      Group['nagios'],
      Group['ssl-cert'],
    ]
  }
}
