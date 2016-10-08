# Class: vision_icinga2::server::install
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_icinga2::server::install
#

class vision_icinga2::server::install {

  class { '::vision_mysql::server':
    root_password => $::vision_icinga2::server::mysql_root_password,
  }

  ::mysql::db { $::vision_icinga2::server::mysql_database:
    user     => $::vision_icinga2::server::mysql_user,
    password => $::vision_icinga2::server::mysql_password,
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

  class { '::icinga2':
    db_type         => 'mysql',
    db_host         => 'localhost',
    db_port         => '3306',
    db_name         => $::vision_icinga2::server::mysql_database,
    db_user         => $::vision_icinga2::server::mysql_user,
    db_pass         => $::vision_icinga2::server::mysql_password,
    use_debmon_repo => false,
    manage_database => false,
    purge_configs   => true,
    purge_confd     => true,
    require         => Mysql::Db[$::vision_icinga2::server::mysql_database],
  }

  class { 'vision_icinga2::server::feature::ido_mysql':
    host     => 'localhost',
    port     => '3306',
    user     => $::vision_icinga2::server::mysql_user,
    password => $::vision_icinga2::server::mysql_password,
    database => $::vision_icinga2::server::mysql_database,
  }

}
