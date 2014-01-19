# Definition: iam_tomcat::deploy::file
#
# This class deploys a web application
#
# Parameters:
#
# - The $path provides the path where the file needs to be copied to
# - The $source/$content provides the path of the file
#
# Sample Usage:
#
#   Simple deployment definition:
#   iam_tomcat::deploy::file { 'postgres_driver':
#   path    =>
#   "${tomcat_lib_dir}/postgresql-9.3-1100.jdbc41.jar",
#   source  => 'puppet:///modules/am-admin/postgresql-9.3-1100.jdbc41.jar',
#   }
#

define iam_tomcat::deploy::file{
    $ensure     => undef,
    $content    => undef,
    $source     => undef,
    $owner      => 'tomcat',
    $group      => 'tomcat',
    $path       ,
) {

  $real_content =  $content?{
    true    => $content,
    false   =>
    $source ? {
       true     => $source,
    },
    default => fail('Need to have either file source or content')
  }

  if $content {
    file { $name:
        ensure  => $ensure,
        content => $content,
        owner   => $owner,
        group   => $group,
    }
  } else {
    if $source {
      file { $name:
        ensure  => $ensure,
        source  => $source,
        owner   => $owner,
        group   => $group,
      }
    } else {
        fail('Need to have either file source or content')
    }
  }
}
