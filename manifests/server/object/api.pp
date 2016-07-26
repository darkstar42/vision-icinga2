# api class
class vision_icinga2::server::object::api (
  String $api_user     = hiera('icinga2::api::username'),
  String $api_password = hiera('icinga2::api::password')
) {
  ::icinga2::object::apiuser { $api_user:
    password => $api_password,
  }
}
