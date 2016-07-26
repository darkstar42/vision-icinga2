# Class: vision_icinga2::common::object
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

class vision_icinga2::common::object (

) {
  contain ::vision_icinga2::common::object::apply
  contain ::vision_icinga2::common::object::checkcommand
  contain ::vision_icinga2::common::object::hostgroup
  contain ::vision_icinga2::common::object::service
  contain ::vision_icinga2::common::object::servicegroup
  contain ::vision_icinga2::common::object::template
  contain ::vision_icinga2::common::object::timeperiod
}
