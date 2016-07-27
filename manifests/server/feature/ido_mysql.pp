
class vision_icinga2::server::feature::ido_mysql (
  $host                 = $::icinga2::db_host,
  $port                 = $::icinga2::db_port,
  $user                 = $::icinga2::db_user,
  $password             = $::icinga2::db_pass,
  $database             = $::icinga2::db_name,
  $table_prefix         = 'icinga_',
  $instance_name        = 'default',
  $instance_description = undef,
  $enable_ha            = true,
  $cleanup              = {
    acknowledgements_age           => 0,
    commenthistory_age             => 0,
    contactnotifications_age       => 0,
    contactnotificationmethods_age => 0,
    downtimehistory_age            => 0,
    eventhandlers_age              => 0,
    externalcommands_age           => 0,
    flappinghistory_age            => 0,
    hostchecks_age                 => 0,
    logentries_age                 => 0,
    notifications_age              => 0,
    processevents_age              => 0,
    statehistory_age               => 0,
    servicechecks_age              => 0,
    systemcommands_age             => 0,
  },
  $categories           = [],
) {

  file { '/tmp/icinga2-ido-mysql.preseed':
    ensure => present,
    source => 'puppet:///modules/vision_icinga2/icinga2-ido-mysql.preseed',
    mode   => '0600',
    backup => false,
  }

  package { 'icinga2-ido-mysql':
    ensure       => $::icinga2::package_ensure,
    require      => File['/tmp/icinga2-ido-mysql.preseed'],
    responsefile => '/tmp/icinga2-ido-mysql.preseed',
  }

  Package['icinga2-ido-mysql'] ->
  exec { 'mysql_schema_load':
    user    => 'root',
    path    => $::path,
    command => "mysql -h '${host}' -u '${user}' -p'${password}' '${database}' < '/usr/share/icinga2-ido-mysql/schema/mysql.sql' && touch /etc/icinga2/mysql_schema_loaded.txt",
    creates => '/etc/icinga2/mysql_schema_loaded.txt',
    require => Mysql::Db[$database],
  }

  ::icinga2::object::idomysqlconnection { 'ido-mysql':
    host                 => $host,
    port                 => $port,
    user                 => $user,
    password             => $password,
    database             => $database,
    table_prefix         => $table_prefix,
    instance_name        => $instance_name,
    instance_description => $instance_description,
    enable_ha            => $enable_ha,
    cleanup              => $cleanup,
    categories           => $categories,
    target_file_name     => 'ido-mysql.conf',
    target_dir           => '/etc/icinga2/features-available',
  } ->

  ::icinga2::feature { 'ido-mysql':
    manage_file => false,
  }
}