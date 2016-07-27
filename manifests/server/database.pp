# Class: vision_icinga2::common::database
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

class vision_icinga2::server::database (
  String  $mysql_database = $::vision_icinga2::server::mysql_database,
  String  $mysql_user     = $::vision_icinga2::server::mysql_user,
  String  $mysql_password = $::vision_icinga2::server::mysql_password,
  String  $mysql_host     = $::vision_icinga2::server::mysql_host,
  Integer $mysql_port     = $::vision_icinga2::server::mysql_port,
) {
  if ($mysql_host == 'localhost') {
    contain vision::profile::mysql::server

    ::mysql::db { $mysql_database:
      user     => $mysql_user,
      password => $mysql_password,
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
  }

  class { '::vision_icinga2::server::feature::ido_mysql':
    host     => $mysql_host,
    port     => $mysql_port,
    user     => $mysql_user,
    password => $mysql_password,
    database => $mysql_database,
  }
}
