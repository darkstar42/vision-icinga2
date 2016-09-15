# Class: vision_icinga2
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

class vision_icinga2 (
  String $type          = 'client',
  String $client_zone   = $::fqdn,
  Hash $vars            = hiera('icinga2::monitoring', { }),
  $parent_zone          = undef,

  Boolean $enable_email = false,
  Boolean $enable_sms   = false,
) {
  contain "::vision_icinga2::${type}"
}