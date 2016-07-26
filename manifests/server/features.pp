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
  contain ::icinga2::feature::notification
}
