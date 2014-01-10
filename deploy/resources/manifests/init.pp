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

  $location = [
    {'path'   => 'castest'},
#    {'path'   => 'am-admin'},
    ]

 notice("DEBUG::main servername is ${servername}")
 notice("DEBUG::main servername top is ${::servername}")
 notice("DEBUG::main servername facter is ${servername}")
  $proxy_pass = [
    {'path'   => 'castest', 'host'  => $servername, 'ajp_port'  => $ajp_port,
            app_name    => 'castest'},
    {'path'   => 'am-admin', 'host' => $servername, 'ajp_port'  => $ajp_port,
            app_name    => 'am_admin'},
    {'path'   => 'manager', 'host'  => $servername, 'ajp_port'  => $ajp_port,
            app_name    => 'manager'},
  ]

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
    location          => $location,
  }

# =====================================
# Install and configure Tomcat
# according to IAM Tomcat installations
# =====================================
  class { 'iam_tomcat':
    shutdown_port     => $shutdown_port,
    ajp_port          => $ajp_port,
    http_port         => $http_port,
    auto_deploy       => false,
    http_enabled      => $http_enabled,
    version           => $tomcat_version,
    java_opts         => '-XX:PermSize=128m -XX:MaxPermSize=128m -Xms512m -Xmx512m',
    install_dir       => '/usr/share',
  }

# ====================================
# Deploy castest application
# ====================================
  $deploy_dir = "${tomcat::install_dir}/tomcat/webapps"
  class{'castest':}

  castest::deploy{'castest':
    deploy_dir  =>   $deploy_dir,
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
    deploy_dir  =>  $deploy_dir,
    path        =>  'puppet:///modules/am-admin/am-admin.war',
  }

################################################
# Postgres
#
################################################
# class { 'postgresql::server': }

# class { 'postgresql::server':
#   ip_mask_deny_postgres_user => '0.0.0.0/32',
#   ip_mask_allow_all_users    => '0.0.0.0/0',
#   listen_addresses           => '*',
#   ipv4acls                   => ['hostssl all johndoe 192.168.0.0/24 cert'],
#   manage_firewall            => true,
#   postgres_password          => 'postgres',
# }

###########################################
# Create a database
###########################################
#class { 'postgresql::server': }

#postgresql::server::db { 'iamdev':
#  user     => 'adminappaccess',
#  password => postgresql_password('adminappaccess', '2orange4me'),
#}

}
