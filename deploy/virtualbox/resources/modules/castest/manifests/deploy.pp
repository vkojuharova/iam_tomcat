# Definition: castest::deploy
#
# This class deploys Castest web application
#
# Parameters:
#
# - The $deploy_dir provides tomcat deploy directory
# - The $path provides the path of the war file to deploy
#
# Sample Usage:
#
#   Simple deployment definition:
#   castest::deploy {
#     'castest':
#       deploy_dir  => "${tomcat::install_dir}/tomcat/webapps",
#       path        =>  "puppet:///modules/castest/castest.war",
#   }
#
define castest::deploy(
    $deploy_dir,
    $path,
) {
  notice("DEBUG::castest::deploy Tomcat deploy dir is ${deploy_dir}")

  notice("DEBUG::castest::deploy path is ${path}")

  file { "${deploy_dir}/${name}.war":
    owner   => 'root',
    source  => $path,
  }
}