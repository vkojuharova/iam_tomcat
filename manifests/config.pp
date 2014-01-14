# == Class: iam_tomcat::config
#
# This class provides default configuration parameters for the IAM Tomcat
# installation
#
class iam_tomcat::config (
    $shutdown_port              = '8005',
    $ajp_port                   = '8009',
    $ajp_redirect_port          = '8443',
    $http_port                  = '8080',
    $http_enabled               = true,
    $ssl_port                   = '8443',
    $auto_deploy                = true,
    $host_name                  = 'localhost',
    $version                    = '7.0.47',
    $install_dir                = '/usr/share',
    $classpath                  = "/usr/share/configuration",
    $app_config_dir             = "/usr/share/configuration",
)
{

}