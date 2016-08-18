# api class
class vision_icinga2::server::object::api (
  String $api_user,
  String $api_password,
) {
  ::icinga2::object::apiuser { $api_user:
    password => $api_password,
  }
}
