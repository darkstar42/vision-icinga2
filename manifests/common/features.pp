# Class: vision_icinga2::common::features
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

class vision_icinga2::common::features (

) {

  # Include features
  contain ::icinga2::feature::checker
  contain ::icinga2::feature::command
  contain ::icinga2::feature::mainlog

  class { '::icinga2::feature::api':
    accept_commands => true,
    accept_config   => false,
    ca_path         => '/vision/pki/VisionCA.crt',
    cert_path       => "/vision/pki/${::fqdn}.crt",
    key_path        => "/vision/pki/${::fqdn}.key",
    crl_path        => false,
    manage_zone     => false,
  }
}
