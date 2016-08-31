# Class: vision_icinga2::server::object
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

class vision_icinga2::server::object () {

  contain ::vision_icinga2::server::object::api
  contain ::vision_icinga2::server::object::host
  contain ::vision_icinga2::server::object::notification
  contain ::vision_icinga2::server::object::notificationcommand
  contain ::vision_icinga2::server::object::user
  contain ::vision_icinga2::server::object::usergroup
  contain ::vision_icinga2::server::object::zone
}
