# class castest
#
class castest {

  include tomcat

  notice("DEBUG::castest::init:: Establishing http://${::hostname}/${::name}/")

  notice('DEBUG::castest::init.pp webapps dir is ')

  notice("${tomcat::install_dir}/tomcat/webapps")

}
