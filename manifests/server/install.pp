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

class vision_icinga2::server::install (
  String  $mysql_database = $::vision_icinga2::server::mysql_database,
  String  $mysql_user     = $::vision_icinga2::server::mysql_user,
  String  $mysql_password = $::vision_icinga2::server::mysql_password,
  String  $mysql_host     = $::vision_icinga2::server::mysql_host,
  Integer $mysql_port     = $::vision_icinga2::server::mysql_port,
) {
  contain vision_icinga2::common::install
  contain vision_icinga2::server::database

  class { '::icinga2':
    db_type          => 'mysql',
    db_host          => $mysql_host,
    db_port          => $mysql_port,
    db_name          => $mysql_database,
    db_user          => $mysql_user,
    db_pass          => $mysql_password,
    use_debmon_repo  => false,
    manage_repos     => false,
    manage_database  => false,
    purge_configs    => true,
    purge_confd      => true,
    default_features => false,
    require          => [Class['vision_icinga2::common::install'], Class['vision_icinga2::server::database']]
  }
}
