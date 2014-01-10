# Definition: apache::vhost
#
# This class installs Apache Virtual Hosts
#
# Parameters:
# - The $mod_auth_cas - use mod_auth_cas module; defaults to true
# - The $proxy_ajp use proxy; defaults to true
# - The $port to configure the host on
# - The $directories to configure the Directories directive for the Virtual Host
# - The $docroot to configure the Document Root
# - The $servername to configure the servername for the Virtual Host.
# - The $cas_cache_folder to configure the Cas cache folder for
# storing cas cookies.
# - The $ajp_port for Tomcat to configure the ProxyPass for the
# Virtual Host
# - The $ip to configure the servername for the Virtual Host
# Actions:
# - Install Apache mod_auth_cas module Virtual Host
#
# Requires:
# - The apache class
#
# Sample Usage:
#
#  # Simple vhost definition:
#  mod_auth_cas::vhost{'mod_auth_cas_vhost':
#          mod_auth_cas  => true,
#          proxy_ajp     => true,
#          port          => $castest_ssl_port,
#          directories   => [
#                { path  => '/',
#                'allow' => 'from all',
#                'order' => 'allow,deny' },
#                ] ,
#          docroot       => '/var/www/castest',
#  }
#
define mod_auth_cas::vhost (
      $mod_auth_cas                = true,
      $proxy_ajp                   = true,
      $port                        = '443',
      $servername                  = $apache::params::servername,
      $cas_cache_folder            = '/mod_auth_cas',
      $ajp_port                    = '8009',
      $cas_login_url               = 'https://stage.pin1.harvard.edu/cas/login',
      $cas_validate_url            = 'https://stage.pin1.harvard.edu/cas/samlValidate',
      $default_ssl_cert            = $apache::params::default_ssl_cert,
      $location                    = undef,
      $directories                 = undef,
      $docroot                     = undef,
      $ip                          = undef,
) {

include  mod_auth_cas::params

#inherits apache::vhost{

#      if $mod_auth_cas {
#           include mod_auth_cas::mod::auth_cas
#      }

# Load mod_ajp if needed and not loaded
  if $proxy_ajp {
      if ! defined(Class['mod_auth_cas::mod::proxy_ajp']) {
        include apache::mod::proxy
        include mod_auth_cas::mod::proxy_ajp
      }
  }

#Mod Auth CAS cache folder
  file { $cas_cache_folder:
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0777',
  }

 notice("DEBUG::mod_auth_cas::location is ${location}")

 file {  'auth_cas':
        ensure  => file,
        path    => "${mod_auth_cas::params::confd_dir}/auth_cas.conf",
        content => template ('mod_auth_cas/mod/auth_cas.conf.erb'),
        require => Exec["mkdir ${apache::mod_dir}"],
        before  => File [$apache::mod_dir],
  }

# Make sure docroot exists
  file {$docroot:
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0777',
  }


  apache::vhost{$::fqdn:
    port            => $port,
    serveradmin     => 'vanja_kojuharova@harvard.edu',
    access_log_file => 'castest_access_log.log',
    priority        => '1',
    docroot         => $docroot,
    ssl             => true,
    custom_fragment =>
        "Include ${mod_auth_cas::params::confd_dir}/auth_cas.conf",
    sslproxyengine  => true ,
    directories     => [
        { path      => $docroot,
        'allow'     => 'from all',
        options     =>['Indexes',  'FollowSymLinks'],
        order       => ['allow','deny']
        } ],
    servername      => $servername,
    ip              => $ip,
  }
}