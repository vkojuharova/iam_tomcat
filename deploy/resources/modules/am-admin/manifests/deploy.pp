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
) {

  require tomcat

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

  $tomcat_lib_dir            = "${tomcat::config::install_dir}/tomcat/lib"
  $tomcat_bin_dir            = "${tomcat::config::install_dir}/tomcat/bin"

#####################################
# Add properties file to classpath
#####################################



  file {  'am-admin-properties':
    ensure  => file,
    path    => "${tomcat_lib_dir}/am-admin.properties",
    content => template ('am-admin/am-admin.properties.erb'),
    owner   => 'tomcat',
    group   => 'tomcat',
  }

  file { 'postgres_driver':
    path    =>
    "${tomcat_lib_dir}/postgresql-9.3-1100.jdbc41.jar",
    source  => 'puppet:///modules/am-admin/postgresql-9.3-1100.jdbc41.jar',
    owner   => 'tomcat',
    group   => 'tomcat',
  }
}