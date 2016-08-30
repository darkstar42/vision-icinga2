# api class
class vision_icinga2::server::object::api () {
  ::icinga2::object::apiuser { $::vision_icinga2::server::api_user:
    password => $::vision_icinga2::server::api_password,
  }
}
