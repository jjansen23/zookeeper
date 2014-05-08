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
class zookeeper {
  require zookeeper::params

   file { "/usr/local/zookeeper-${zookeeper::params::version}.tar.gz":
    ensure => present,
     mode    => '640',
     source  => "puppet:///modules/zookeeper/zookeeper-${zookeeper::params::version}.tar.gz",
    }

 exec {"remove_zookeeper":
       command => '/bin/rm -rf /opt/zookeeper',
       refreshonly => false,
     }
     
   exec { "untar_zookeeper": 
       command => "/bin/tar -xzvf /usr/local/zookeeper-${zookeeper::params::version}.tar.gz",
       refreshonly => false,
       cwd => "${zookeeper::params::install_dir}",
       require => Exec[remove_zookeeper],
     } 
      
   exec {"rename_zookeeper":
       command => "/bin/mv /opt/zookeeper-${zookeeper::params::version} /opt/zookeeper",
       refreshonly => false,       
       require => Exec[untar_zookeeper],
       }    
    
     exec {"change_zk_owner":
      command => '/bin/chown -R hduser:hadoop /opt/zookeeper',
      refreshonly => false,      
       require => Exec[rename_zookeeper],       
       }
  

   file { "${zookeeper::params::zookeeper_base}/conf/zkEnv.sh":
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
    alias => 'zkEnv.sh',
    content => template('zookeeper/zkEnv.sh.erb'),
  }  

   file { "${zookeeper::params::zookeeper_base}/conf/zookeeper_log.cron":
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
    alias => 'zookeeper_log.cron',
    content => template('zookeeper/zookeeper_log.cron.erb'),
   }
  
  file { "${zookeeper::params::zookeeper_base}/bin/zkServer.sh":
    ensure   => file,
    path      => "${zookeeper::params::zookeeper_base}/bin/zkServer.sh",
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
    alias => 'zkServer.sh',
    content => template('zookeeper/zkServer.sh.erb'),
  }

   file { "/etc/init.d/zookeeper":
     ensure => link,
     target => "${zookeeper::params::zookeeper_base}/bin/zkServer.sh",
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
   require => File["${zookeeper::params::zookeeper_base}/bin/zkServer.sh"] 
  }  
  
   file { "${zookeeper::params::zookeeper_base}/conf/zoo.cfg":
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
    alias => 'zoo.cfg',
    content => template('zookeeper/zoo.cfg.erb'),
   require => File["${zookeeper::params::zookeeper_base}/bin/zkServer.sh"] 
  }    
  
   file { "/tmp/zookeeper":
     ensure => directory,
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
  }  
 
    exec {"add-zookeeper-service":
    command => '/sbin/chkconfig --add zookeeper',
     refreshonly => false,      
     require => File['/etc/init.d/zookeeper'],       
      }

    service {'zookeeper':
    #ensure => running,
   # enable => true,
    hasstatus => true,
    hasrestart => true,
   }    
}
