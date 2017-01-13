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
  String $fqdn         = $::fqdn,

) {

  # Include features
  contain ::icinga2::feature::checker
  contain ::icinga2::feature::mainlog

  contain vision_icinga2::common::feature::api
}
