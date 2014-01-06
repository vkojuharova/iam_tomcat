# == Class: tomcat_iam
#
# This class does ot do anything
#
class tomcat_iam(
    $shutdown_port      = $tomcat_iam::config::shutdown_port,
    $ajp_port           = $tomcat_iam::config::ajp_port,
    $http_port          = $tomcat_iam::config::http_port,
    $ssl_port           = $tomcat_iam::config::ssl_port,
    $auto_deploy        = $tomcat_iam::config::auto_deploy,
    $http_enabled       = $tomcat_iam::config::http_enabled,
    $host_name          = $tomcat_iam::config::host_name,
    $manage             = true,
    $version            = $tomcat_iam::config::version,
) inherits tomcat_iam::config {

# Install Tomcat with custom server.xml header:
  class { 'tomcat':
    version             => $version,
    header_fragment     => 'tomcat_iam/server.xml.header.erb',
  }

  notice('DEBUG::tomcat_iam::  FINITTOoo...')

}