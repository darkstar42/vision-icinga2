# = Class: vision_icinga2::common::object::template

class vision_icinga2::common::object::template {
  file { '/etc/icinga2/objects/templates/templates.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('vision_icinga2/server/object/templates.conf'),
    notify  => Service['icinga2'],
  }
}
