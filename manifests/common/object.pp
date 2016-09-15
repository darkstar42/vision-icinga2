# Class: vision_icinga2::common::object
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

class vision_icinga2::common::object {
  contain ::vision_icinga2::common::object::apply
  contain ::vision_icinga2::common::object::checkcommand
  contain ::vision_icinga2::common::object::host
  contain ::vision_icinga2::common::object::hostgroup
  contain ::vision_icinga2::common::object::service
  contain ::vision_icinga2::common::object::servicegroup
  contain ::vision_icinga2::common::object::template
  contain ::vision_icinga2::common::object::timeperiod

  contain ::vision_monitoring

  # Hash
  $local_vars = {
    'os'            => $::kernel,
    'vm'            => $::is_virtual,
    'distro'        => $::operatingsystem,
    'parent'        => $::vision_icinga2::parent_zone,
    'remote_client' => $::fqdn,
    'notification'  => {
      'email' => $::vision_icinga2::enable_email,
      'sms'   => $::vision_icinga2::enable_sms,
    }
  }
  # Array of Hashes
  $ress_vars = query_resources(false,
    ['and',
      ['=', 'type', 'Vision_Icinga2::Monitoring_parameters'],
      ['=', 'certname', $::fqdn],
    ])

  # Merge gleichnamige parameter
  # =>
  # processes:
  #     apache:
  #         procname: apache2
  #     icinga:
  #         procname: icinga2

  # lint:ignore:variable_scope
  $merge = $ress_vars.reduce({}) |$value, $mon_param| {
      deep_merge($value, $mon_param['parameters']['vars'])
    }
  # lint:endignore

  # merge alle monitoring_vars aus den Quellen:
  #   - lokal (hier in der Datei definiert)
  #   - exportiert (vars die in anderen profilen exportiert und
  #   in der puppetdb gespeichert werden)
  #   - hiera (node/role/...)
  $exported_vars = deep_merge($local_vars, $merge)
  $vars = deep_merge($exported_vars, $::vision_icinga2::vars)

  ::icinga2::object::host { $::fqdn:
    target_file_name => "${::fqdn}.conf",
    display_name     => $::fqdn,
    ipv4_address     => $::ipaddress_eth0,
    vars             => $vars,
  }

}
