# Definition: am-admin::deploy
#
# This class deploys am-admin web application
#
# Parameters:
#
# - The $deploy_dir provides tomcat deploy directory
# - The $path provides the path of the war file to deploy
#
# Sample Usage:
#
#   Simple deployment definition:
#   am-admin::deploy {
#     'am-admin':
#       deploy_dir  => "${tomcat::install_dir}/tomcat/webapps",
#       path        =>  "puppet:///modules/am-admin/am-admin.war",
#   }
#
define am-admin::deploy(
    $deploy_dir,
    $path,
	$servername,
) {
  notice("DEBUG::am-admin::deploy Tomcat deploy dir is ${deploy_dir}")

  notice("DEBUG::am-admin::deploy path is ${path}")

  notice("DEBUG::am-admin::deploy servername is ${servername}")

  notice("DEBUG::am-admin::deploy war file name is ${name}.war")
  
  file { "${deploy_dir}/${name}.war":
    owner   => 'root',
    source  => $path,
  }
  
  file {  'am-admin-httpd-conf':
        ensure  => file,
        path    => "${apache::params::confd_dir}/am-admin.conf",
        content => template ('am-admin/mod/am-admin.conf.erb'),
        require => Exec["mkdir ${apache::mod_dir}"],
        before  => File [$apache::mod_dir],
  }
  
}