# documentation
class vision_icinga2::common::object::dependency {
  ::icinga2::object::apply_dependency { 'parent':
    parent_host_name      => '$host.vars.parent$',
    assign_where          => 'host.address && host.vars.parent',
    disable_notifications => true,
    disable_checks        => true
  }
}
