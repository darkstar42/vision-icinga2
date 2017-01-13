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

class vision_icinga2::server::features (

) {

  #contain ::icinga2::feature::notification
  contain ::icinga2::feature::statusdata
  contain ::icinga2::feature::compatlog
  contain ::icinga2::feature::command
}
