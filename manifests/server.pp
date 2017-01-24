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
# contain ::vision_icinga2::server
#

class vision_icinga2::server (

  String $api_user,
  String $api_password,

  String $mysql_user,
  String $mysql_password,
  String $mysql_database,
  Boolean $manage_mysql,

  String $notification_group,
  String $notification_email,
  String $notification_slack_webhook_url,
  String $notification_slack_channel,
  String $notification_slack_bot_name,

  Hash $notification_users,
  Hash $notification_groups,

  String $notification_slack_icinga_host = $::fqdn,

) {

  contain ::vision_icinga2::common::install
  contain ::vision_icinga2::server::install

  contain ::vision_icinga2::common::features
  contain ::vision_icinga2::server::features

  contain ::vision_icinga2::common::object
  contain ::vision_icinga2::server::object

}
