# class am-admin
#
class am-admin {

  include tomcat

  include apache::params

  notice("DEBUG::am-admin::init:: Establishing http://${::hostname}/${::name}/")

  notice('DEBUG::am-admin::init.pp webapps dir is ')

  notice("${tomcat::install_dir}/tomcat/webapps")
  
  notice("DEBUG::apache::params::confd_dir: ${apache::params::confd_dir}" )

}
