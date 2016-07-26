# Class: vision_icinga2::server
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

class vision_icinga2::server (

) {
  contain ::vision_icinga2::common::install

  contain ::vision_icinga2::common::features

  contain ::icinga2::feature::notification
}