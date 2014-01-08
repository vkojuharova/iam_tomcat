class mod_auth_cas::params (
    $servername             = $apache::params::servername,
    $confd_dir              = $apache::params::confd_dir,
) inherits apache::params {

    notice("DEBUG::mod_auth_cas::params:: servername is $servername")
}