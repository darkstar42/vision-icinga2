# = Class: vision_icinga2::server::object::endpoint

class vision_icinga2::server::object::endpoint (
  $zone = hiera('icinga2::zone', $::fqdn),
) {

  # $child_nodes = query_resources(false,
  #   ['and',
  #     ['=', 'type', 'Class'],
  #     ['=', 'title', 'vision_icinga2::Base::Monitoring'],
  #     ['=', ['parameter', 'parent_zone'], $zone]]);

  # each ($child_nodes) |$child_node| {
  #   $child_params = $child_node['parameters']

  #   $endpoints = query_resources(false,
  #     ['and',
  #       ['=', 'type', 'Icinga2::Object::Endpoint'],
  #       ['=', 'certname', "${child_node['certname']}"]])

  #   each ($endpoints) |$endpoint| {
  #     $endpoint_params = $endpoint['parameters']


  #     if ! defined(Icinga2::Object::Endpoint["${endpoint['title']}"]) {

  #       ::icinga2::object::endpoint { $endpoint['title']:
  #         host => $endpoint_params['host'],
  #         port => $endpoint_params['port'],
  #         log_duration => $endpoint_params['log_duration'],
  #         target_dir => $endpoint_params['target_dir'],
  #         file_name => $endpoint_params['file_name'],
  #       }
  #     }
  #   }
  # }


  #::Icinga2::Object::Endpoint <<| |>> { }
}
