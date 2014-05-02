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

  $my_message = "zookeeper will be install"
  notify {$my_message:}
  
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
  
   file { "${zookeeper::params::zookeeper_base}/conf/zoo.cfg":
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
    alias => 'zoo.cfgl',
    content => template('zookeeper/zoo.cfg.erb'),
  }  

   file { "/tmp/zookeeper":
     ensure => directory,
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
  }  

   file { "/etc/init.d/zookeeper":
     ensure => link,
     target => '/opt/zookeeper/bin/zkServer.sh',
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
  }  

   #   exec {"add-zookeeper-service":
   #   command => '/sbin/chkconfig --add zookeeper',
   #   refreshonly => false,      
   #    require => File["/etc/init.d/zookeeper"],       
   #    }

  #  service {'zookeeper':
   #  ensure => running,
   # enable => true,
   # hasstatus => true,
   # hasrestart => true,
   #}    
}
