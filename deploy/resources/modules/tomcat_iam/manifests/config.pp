# == Class: tomcat_iam::config
#
# This class provides default configuration parameters for the IAM Tomcat
# installation
#
class tomcat_iam::config (
    $shutdown_port              = '8005',
    $ajp_port                   = '8009',
    $ajp_redirect_port          = '8443',
    $http_port                  = '8080',
    $http_enabled               = true,
    $ssl_port                   = '8443',
    $auto_deploy                = true,
    $host_name                  = 'localhost',
    $version                    = '7.0.47',
    $install_dir                = undef,
    $application_configuration  = undef,
)  inherits   tomcat::config
{


    $install_dir                = $tomcat::config::install_dir
    $application_configuration  = $tomcat::config::install_dir/configuration

}