class zookeeper::params{
  $user = $::zookeeper_user ? {
    default     => "hduser",
  }
  $group = $::zookeeper_group ? {
    default     => "hadoop",
  }
  $version = $::zookeeper_version ? {
    default     => "3.3.6",
  }
   $zookeeper_base = $::zookeeper ? {
    default     => "/opt/zookeeper",
  }
  $install_dir    = $::zookeeper_install ? {
    default => "/opt",
   }
   
}