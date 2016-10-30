# icingaweb2 profile
class vision_icinga2::icingaweb2 (
  String $mysql_database,
  String $mysql_user,
  String $mysql_password,
  String $icinga_mysql_database,
  String $icinga_mysql_user,
  String $icinga_mysql_password,
  String $ldap_bind_dn,
  String $ldap_bind_pw,
  String $ldap_host,
  Numeric $ldap_port,
  String $ldap_base,
  String $ldap_filter,
  String $admin_group,
  Boolean $manage_apache_vhost,
  Hash $groups = hiera_hash('vision::groups'),
) {
  contain ::vision_pki

  #contain ::vision_mysql::server

  #contain vision::profile::ldap::client

  ::mysql::db { $mysql_database:
    user     => $mysql_user,
    password => $mysql_password,
    host     => '%',
    grant    => [
      'SELECT',
      'UPDATE',
      'CREATE',
      'INSERT',
      'INDEX',
      'ALTER',
      'DELETE',
      'DROP',
    ],
  }

  if has_key($groups, $admin_group) {
    $group = $groups[$admin_group]

    $admin_users = join($group['members'], ',')
  } else {
    $admin_users = ''
  }

  class { '::icingaweb2':
    admin_users         => $admin_users,
    install_method      => 'git',
    manage_apache_vhost => $manage_apache_vhost,
    ido_db_name         => $icinga_mysql_database,
    ido_db_user         => $icinga_mysql_user,
    ido_db_pass         => $icinga_mysql_password,
    web_db_name         => $mysql_database,
    web_db_user         => $mysql_user,
    web_db_pass         => $mysql_password,
    require             => [
      Mysql::Db[$mysql_database],
      Mysql::Db[$icinga_mysql_database],
    ]
  }

  include ::icingaweb2::mod::monitoring

  ::icingaweb2::config::resource_ldap { 'vision_ldap':
    resource_bind_dn => $ldap_bind_dn,
    resource_bind_pw => $ldap_bind_pw,
    resource_host    => $ldap_host,
    resource_port    => $ldap_port,
    resource_root_dn => $ldap_base,
  }
    # resource_encryption => 'ldaps',

  ::icingaweb2::config::authentication_ldap { 'auth_ldap':
    auth_section        => 'auth_ldap',
    auth_resource       => 'vision_ldap',
    user_name_attribute => 'uid',
    base_dn             => $ldap_base,
    filter              => $ldap_filter,
  }

  exec { 'create db scheme':
    command => "/usr/bin/mysql --defaults-file='/root/.my.cnf' ${mysql_database} < /usr/share/icingaweb2/etc/schema/mysql.schema.sql",
    unless  => "/usr/bin/mysql --defaults-file='/root/.my.cnf' ${mysql_database} -e \"SELECT 1 FROM icingaweb_user LIMIT 1;\"",
    notify  => Exec['create web user'],
    require => Mysql::Db[$mysql_database],
  }

  # icingaadmin : icingaadmin
  exec { 'create web user':
    command     => "/usr/bin/mysql --defaults-file='/root/.my.cnf' ${mysql_database} -e \" INSERT INTO icingaweb_user (name, active, password_hash) VALUES ('icingaadmin', 1, '\\\$1\\\$2NObEY5e\\\$TVsdtWZi6LW9aaTJyzhd71');\"",
    refreshonly => true,
  }
}
