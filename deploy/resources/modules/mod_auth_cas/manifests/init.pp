# = Class: mod_auth_cas
#
# Manages Apache mod_auth_cas module for Cas integration
#
class mod_auth_cas {

  include mod_auth_cas::params


  file {'/var/www':
          ensure  => directory,
          owner   => 'root',
          group   => 'root',
          mode    => '0777',
    }

#  $servername    = $mod_auth_cas::params::servername

#  notice("DEBUG::mod_auth_cas::init confd_dir is
#  ${mod_auth_cas::params::confd_dir}")

#  notice("DEBUG::mod_auth_cas::init servername is ${servername}")

#  file {  'auth_cas':
#        ensure  => file,
#        path    => "${mod_auth_cas::params::confd_dir}/auth_cas.conf",
#        content => template ('mod_auth_cas/mod/auth_cas.conf.erb'),
#        require => Exec["mkdir ${apache::mod_dir}"],
#        before  => File [$apache::mod_dir],
#  }

  file {'mod_auth_cas.so':
        ensure  => file,
        path    => '/usr/lib64/httpd/modules/mod_auth_cas.so',
        source  => 'puppet:///modules/mod_auth_cas/mod_auth_cas.so',
        group   => 'root',
        owner   => 'root',
        mode    => '0755',
        notify  => Class['Apache::Service'],
        require => Package['httpd'],
  }
  notice("DEBUG::mod_auth_cas::init: Servername from params is
  ${mod_auth_cas::params::servername}")
  notice("DEBUG::mod_auth_cas::init: Name is ${name}")
  notice("DEBUG::mod_auth_cas::init: top level Host is ${::hostname}")
  notice("DEBUG::mod_auth_cas::init: top level FQDN is ${::fqdn}")
  notice("DEBUG::mod_auth_cas::init: top level nvh_addr_port is
  ${::nvh_addr_port}")
  notice("DEBUG::mod_auth_cas::init: top level vhost_name is  ${::vhost_name}")

}