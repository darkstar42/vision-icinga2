# Class: vision_icinga2::client::install
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_icinga2::client::install
#
class vision_icinga2::client::install {

  class { '::icinga2':
    db_type          => 'none',
    use_debmon_repo  => false,
    manage_repos     => false,
    purge_configs    => true,
    purge_confd      => true,
    default_features => false,
    require          => Exec['icinga2-apt-update'],
  }

}
