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
# contain ::vision_icinga2::common:features
#

class vision_icinga2::common::features (

  String $pki_ca_name,
  String $pki_path,
  String $fqdn      = $::fqdn,

) {

  # Include features
  contain ::icinga2::feature::checker
  contain ::icinga2::feature::command
  contain ::icinga2::feature::mainlog

  class { '::icinga2::feature::api':
    accept_commands => true,
    accept_config   => true,
    ca_path         => "${pki_path}/${pki_ca_name}.crt",
    cert_path       => "${pki_path}/${fqdn}.crt",
    key_path        => "${pki_path}/${fqdn}.key",
    crl_path        => false,
    manage_zone     => false,
  }

}
