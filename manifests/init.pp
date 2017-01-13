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

  String $type,
  String $zone,

  String $address,

  String $api_host,
  Integer $api_port,

  Hash $vars,
  Optional[String] $parent_zone,

  Boolean $enable_email,
  Boolean $enable_sms,

) {

  contain "::vision_icinga2::${type}"

}
