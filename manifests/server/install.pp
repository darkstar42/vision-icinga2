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

  class { 'vision_icinga2::server::feature::ido_mysql':
    host     => '127.0.0.1',
    port     => '3306',
    user     => $::vision_icinga2::server::mysql_user,
    password => $::vision_icinga2::server::mysql_password,
    database => $::vision_icinga2::server::mysql_database,
  }
}
