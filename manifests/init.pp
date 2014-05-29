# Class: zookeeper
#
# This module manages zookeeper
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class zookeeper::init {
  require zookeeper::params

   file { "/usr/local/zookeeper-${zookeeper::params::version}.tar.gz":
    ensure => present,
     mode    => '640',
     source  => "puppet:///modules/zookeeper/zookeeper-${zookeeper::params::version}.tar.gz",
    }

#   file {"${zookeeper::params::install_dir}":
#         ensure => absent,
#         force  => true,
#        }
        
 exec {"remove_zookeeper":
       command => "/bin/rm -rf ${zookeeper::params::install_dir}",
       refreshonly => false,
     }
     
   exec { "untar_zookeeper": 
       command => "/bin/tar -xzvf /usr/local/zookeeper-${zookeeper::params::version}.tar.gz",
       refreshonly => false,
       cwd => "/usr/local/",
       require => Exec[remove_zookeeper],
     } 
      
         
   exec {"rename_zookeeper":
       command => "/bin/mv /usr/local/zookeeper-${zookeeper::params::version} /usr/lib/zookeeper/",
       refreshonly => false,       
       require => Exec[untar_zookeeper],
       }    
    
     exec {"change_zk_owner":
      command => "/bin/chown -R ${zookeeper::params::user}:${zookeeper::params::group} ${zookeeper::params::install_dir}",
      refreshonly => false,      
       require => Exec[rename_zookeeper],       
       }
  
}
