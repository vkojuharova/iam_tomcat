# = Class: iam_firewall::post
#
# IAM default rules to be applied last.
#
#
class iam_firewall::post{

  firewall { '999 drop all':
    proto   => 'all',
    action  => 'drop',
    before  => undef,
  }
}