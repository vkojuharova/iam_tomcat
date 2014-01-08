# Class: mod_auth_cas::mod::proxy_ajp
# This class loads proxy_ajp module for Apache
#
class mod_auth_cas::mod::proxy_ajp {
  Class['apache::mod::proxy'] -> Class['mod_auth_cas::mod::proxy_ajp']
  apache::mod { 'proxy_ajp': }
}
