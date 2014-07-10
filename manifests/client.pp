# = Class softec_backuppc::client
#
# wrapper of backuppc::client. Call backuppc::client with customized parameter for softec environment.
# Also creates a test file under /etc/restoretest
#
# == Params
#
# [*user*]
#   local user on client machine used by server to connect to. Default: softecbackuppc
#
# [*user_uid*]
#   user uid. Default: 3005
#
# [*user_gid*]
#   user gid. Default: 3005
#
# [*home*]
#   user home. Default: /var/lib/$user
#
# [*server_tag*]
#   tag used to import ssh_key of server's user. Default: softec_backuppc
#
class softec_backuppc::client (
  $user         = 'softecbackuppc',
  $user_gid     = '3005',
  $user_uid     = '3005',
  $home         = '',
  $server_tag   = 'softec_backuppc',
) {

  $real_home = $home? {
    ''      => "/var/lib/${user}",
    default => $home
  }

  class {'backuppc::client':
    user          => $user,
    user_uid      => $user_uid,
    user_gid      => $user_gid,
    home          => $real_home,
    server_tag    => $server_tag,
    use_ssh_auth  => true,
  }

  #Fx - file civetta #1137
  file {'/etc/restoretest':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    content => "#Generated by puppet\nripristino backuppc",
  }

}
