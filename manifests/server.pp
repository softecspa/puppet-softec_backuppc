# = Class softec_backuppc::server
#
# wrapper of backuppc::server. Call backuppc::server with customized parameter for softec environment.
# Also creates a test file under /etc/restoretest
#
# == Params
#
# [*user*]
#   user for backuppc service. Default: backuppc
#
# [*user_uid*]
#   user uid. Default: ''
#
# [*user_gid*]
#   user gid. Default: ''
#
# [*home*]
#   user home. Default: /var/lib/$user
#
# [*server_tag*]
#   tag used to export ssh_key of user. Default: softec_backuppc
#
class softec_backuppc::server (
  $user         = 'backuppc',
  $home         = '',
  $user_uid     = '',
  $user_gid     = '',
  $server_tag   = 'softec_backuppc',
) {

  $real_home = $home? {
    ''      => "/var/lib/${user}",
    default => $home
  }

  class {'backuppc::server':
    user         => $user,
    home         => $real_home,
    user_uid     => $user_uid,
    user_gid     => $user_gid,
    server_tag   => $server_tag,
    use_ssh_auth => true,
  }

  softec_sudo::conf {'backuppc_nagios':
    source  => 'puppet:///modules/softec_backuppc/etc/sudo_server'
  }
}
