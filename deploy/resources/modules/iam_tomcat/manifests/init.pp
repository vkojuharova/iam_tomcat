# == Class: iam_tomcat
#
#
class iam_tomcat(
    $shutdown_port      = $iam_tomcat::config::shutdown_port,
    $ajp_port           = $iam_tomcat::config::ajp_port,
    $http_port          = $iam_tomcat::config::http_port,
    $ssl_port           = $iam_tomcat::config::ssl_port,
    $auto_deploy        = $iam_tomcat::config::auto_deploy,
    $http_enabled       = $iam_tomcat::config::http_enabled,
    $host_name          = $iam_tomcat::config::host_name,
    $manage             = true,
    $version            = $iam_tomcat::config::version,
    $classpath          = $iam_tomcat::config::classpath,
    $install_dir        = $iam_tomcat::config::classpath,
    $app_config_dir     = $iam_tomcat::config::app_config_dir,
    $java_opts,
) inherits iam_tomcat::config {

  if $classpath {
    $java_opts_classpath=
        "${java_opts} \" export CLASSPATH=\"${classpath}"
  } else {
    $java_opts_classpath=
              "${java_opts} \" export CLASSPATH=\"${app_config_dir}"
  }

  notice("DEBUG::iam_tomcat application configuration ${app_config_dir}")
  notice("DEBUG::iam_tomcat application configuration ${app_config_dir}")
  notice("DEBUG::iam_tomcat application java_opts \" ${java_opts_classpath} \" ")

  file{'application_configuration':
    ensure  => directory,
    path    => $app_config_dir,
    notify  => Class['tomcat::service'],
    owner   => 'tomcat',
    group   => 'tomcat',
  }

# Install Tomcat with custom server.xml header:
  class { 'tomcat':
    version             => $version,
    header_fragment     => 'iam_tomcat/server.xml.header.erb',
    java_opts           => $java_opts_classpath,
  }
}