# = Class: vision_icinga2::server::object::usergroup
#
# == Parameters:
  #
  # [*notification_group]
  #
  # Default: vision-sysadmin

class vision_icinga2::server::object::usergroup (
  String $notification_group = hiera('icinga2::notification::group', 'vision-sysadmin'),
) {
  ::icinga2::object::usergroup { $notification_group:
  }
}
