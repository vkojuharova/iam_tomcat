# == Class: tomcat_iam
#
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

  $application_configuration = "${tomcat::config::install_dir}/configuration"

  notice("DEBUG::tomcat_iam application configuration ${application_configuration}")

  file{'application_configuration':
    ensure  => directory,
    path    => $application_configuration,
    notify  => Class['tomcat::service'],
  }

# Install Tomcat with custom server.xml header:
  class { 'tomcat':
    version             => $version,
    header_fragment     => 'tomcat_iam/server.xml.header.erb',
    java_opts           =>
    "-XX:+DoEscapeAnalysis -XX:+UseConcMarkSweepGC   -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:PermSize=128m -XX:MaxPermSize=128m -Xms512m -Xmx512m export CLASSPATH=${application_configuration}",

  }

  notice('DEBUG::tomcat_iam::  FINITTOoo...')

}