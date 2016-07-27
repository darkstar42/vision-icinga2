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

class vision_icinga2::client::install (

) {
  contain vision_icinga2::common::install

  class { '::icinga2':
    db_type          => 'none',
    use_debmon_repo  => false,
    manage_repos     => false,
    purge_configs    => true,
    purge_confd      => true,
    default_features => false,
    require          => Class['vision_icinga2::common::install']
  }
}
