node default {

  $castest_ssl_port     = '8017'
  $default_http_port    = '80'
  $default_ssl_port     = '443'
  $ajp_port             = '8009'
  $shutdown_port        = '8005'
  $http_port            = '8016'
  $http_enabled         = true
  $tomcat_version       = '7.0.47'

  stage { 'pre': before => Stage['main'] }
  class { 'epel': stage => 'pre' }
  class { 'common': }

# ===================================
# Firewall updates. Those will need
# to be restricted more.
# ===================================
  resources { 'firewall':
    purge => true
  }
  Firewall {
    before  => Class['iam_firewall::post'],
    require => Class['iam_firewall::pre'],
  }
  class { ['iam_firewall::pre', 'iam_firewall::post']: }

# Firewall rules for current project. Need to secure it more as currently we
# can access http://10.11.12.13/ and the forwarded one http://127.0.0.1:8080/
# https://10.11.12.13:8017/castest - accessible
# https://127.0.0.1:8017/castest - this is not accessible
#
  firewall { '011 allow http and https access':
    ensure    => 'present' ,
    action    => 'accept',
    proto     => 'tcp',
    dport     => [$default_ssl_port,$default_http_port, $castest_ssl_port, $http_port],
  }
  notice ("DEBUG::master init:: servername is $servername")
# ===================================
# Install and configure Apache
# ===================================
  class { 'apache': }

# ===================================
# Install and configure mod_auth_cas
# Apache module
# ===================================
  class { 'mod_auth_cas': }

  mod_auth_cas::vhost{'mod_auth_cas_vhost':
    mod_auth_cas      => true,
    proxy_ajp         => true,
    port              => $castest_ssl_port,
    directories       => [
            { path    => '/',
            'allow'   => 'from all',
            'order'   => 'allow,deny' },
            ] ,
    docroot           => '/var/www/castest',
    servername        => $servername,
    ajp_port          => $ajp_port,
    cas_login_url     =>
      'https://webdev1ox.iam.huit.harvard.edu:8016/cas/login',
    cas_validate_url  =>
      'https://webdev1ox.iam.huit.harvard.edu:8016/cas/samlValidate',
  }

  
# Install and configure Tomcat
  class { 'tomcat':
    version => '7.0.47',
  }
  
# =====================================
# Install and configure Tomcat
# according to IAM Tomcat installations
# =====================================
#  class { 'tomcat_iam':
#    shutdown_port     => $shutdown_port,
#    ajp_port          => $ajp_port,
#    http_port         => $http_port,
#    auto_deploy       => false,
#    http_enabled      => $http_enabled,
##    host_name         => 'castest',
#    version           => $tomcat_version,
#  }

# ====================================
# Deploy castest application
# ====================================
  class{'castest':}

  castest::deploy{'castest':
    deploy_dir  =>   "${tomcat::install_dir}/tomcat/webapps",
    path        =>  'puppet:///modules/castest/castest.war',
  }

# ====================================
# Deploy any additional applications
# using the castest example above
# ====================================
 
# ====================================
# Deploy am-admin application
# ====================================
  class{'am-admin':}

  am-admin::deploy{'am-admin':
    deploy_dir  =>   "${tomcat::install_dir}/tomcat/webapps",
    path        =>  'puppet:///modules/am-admin/am-admin.war',
	servername 		=>  $apache::params::servername,
  }

  
}
