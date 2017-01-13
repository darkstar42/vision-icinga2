#
class vision_icinga2::common::feature::api (

) {

  class { '::icinga2::feature::api':
    accept_config   => true,
    accept_commands => true,
    pki             => 'puppet',
    endpoints       => {},
    zones           => {},
  }
}
