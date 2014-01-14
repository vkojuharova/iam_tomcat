# Definition: iam_tomcat::deploy::war
#
# This class deploys a web application
#
# Parameters:
#
# - The $deploy_dir provides tomcat deploy directory
# - The $path provides the path of the war file to deploy
#
# Sample Usage:
#
#   Simple deployment definition:
#   iam_tomcat::deploy::war {
#     'castest':
#       deploy_dir  => "${tomcat::install_dir}/tomcat/webapps",
#       path        =>  "puppet:///modules/castest/castest.war",
#   }
#

define iam_tomcat::deploy::war{
    $deploy_dir,
    $path,
) {
  notice("DEBUG::iam_tomcat::war Tomcat deploy dir is ${deploy_dir}")

  notice("DEBUG::iam_tomcat::war source path is ${path}")

  file { "${deploy_dir}/${name}.war":
    owner   => 'root',
    source  => $path,
    owner   => 'tomcat',
    group   => 'tomcat',
  }

}
