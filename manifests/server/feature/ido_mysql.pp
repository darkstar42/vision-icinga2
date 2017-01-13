#
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
  $categories           = undef,

) {

  ::mysql::db { $database:
    user     => $user,
    password => $password,
    host     => '%',
    grant    => [
      'SELECT',
      'UPDATE',
      'CREATE',
      'INSERT',
      'INDEX',
      'ALTER',
      'DELETE',
      'DROP',
    ],
  }

  class { '::icinga2::feature::idomysql':
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
    import_schema        => true,
    require              => Mysql::Db[$database]
  }
}
