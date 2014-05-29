class zookeeper::params{
  $user = $::zookeeper_user ? {
    default     => "root",
  }
  $group = $::zookeeper_group ? {
    default     => "root",
  }
  $version = $::zookeeper_version ? {
    default     => "3.3.6",
  }
   $zookeeper_base = $::zookeeper ? {
    default     => "/opt/zookeeper",
  }
  $install_dir    = $::zookeeper_install ? {
    default => "/usr/lib/zookeeper/",
   }
 $zookeeper_server    = $::zookeeper_server ? {
    default => "zookeeper_server",
   }   
  $zookeeper_server_1    = $::zookeeper_server_1 ? {
    default => "puppet-agent.localdomain",
   }
  $zookeeper_server_2    = $::zookeeper_server_2 ? {
    default => "puppet-agent2.localdomain",
   }
  $zookeeper_server_3    = $::zookeeper_server_3 ? {
    default => "zookeeper_server_3",
   }      
}
