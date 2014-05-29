class zookeeper::conf {
      require zookeeper::params
   
    File {
        ensure => file, 
        owner => "${zookeeper::params::user}",
        group => "${zookeeper::params::group}",
        mode => '644',        
     }
     
   file { "${zookeeper::params::install_dir}/conf/zkEnv.sh":
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
    alias => 'zkEnv.sh',
    content => template('zookeeper/zkEnv.sh.erb'),
  }  

   file { "${zookeeper::params::install_dir}/conf/zookeeper_log.cron":
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
    alias => 'zookeeper_log.cron',
    content => template('zookeeper/zookeeper_log.cron.erb'),
   }
  
  file { "${zookeeper::params::install_dir}/bin/zkServer.sh":
    ensure   => file,
    path      => "${zookeeper::params::install_dir}/bin/zkServer.sh",
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
    alias => 'zkServer.sh',
    content => template('zookeeper/zkServer.sh.erb'),
  }

   file { "/etc/init.d/zookeeper-server":
    source => "puppet:///modules/zookeeper/conf/zookeeper-server",
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '755',
  }  
  
   file { "${zookeeper::params::install_dir}/conf/zoo.cfg":
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
    alias => 'zoo.cfg',
    content => template('zookeeper/zoo.cfg.erb'),
   require => File["${zookeeper::params::install_dir}/bin/zkServer.sh"] 
  }    
  
   file { "/tmp/zookeeper":
     ensure => directory,
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
  }  

   file { "/data":
     ensure => directory,
     owner => "${zookeeper::params::user}",
     group => "${zookeeper::params::group}",
     mode => '644',
  }
  
    file { "/data/0/":
     ensure => directory,
    owner => "${zookeeper::params::user}",
    group => "${zookeeper::params::group}",
    mode => '644',
    require => File["/data"]
  }
  
  if $fqdn == "$zookeeper_server_1" 
    {
      file { "/data/0/myid":
      ensure => file,
      backup => false,
      content => "0",
      owner => "${zookeeper::params::user}",
      group => "${zookeeper::params::group}",
      mode => '644',
      require => File["/data/0/"]
      }  
    }
    
    if $fqdn == "$zookeeper_server_2" 
    {
      file { "/data/0/myid":
      ensure => file,
      backup => false,
      content => "1",
      owner => "${zookeeper::params::user}",
      group => "${zookeeper::params::group}",
      mode => '644',
      require => File["/data/0/"]
      }  
    }
    
    if $fqdn == "$zookeeper_server_3" 
    {
      file { "/data/0/myid":
      ensure => file,
      backup => false,
      content => "2",
      owner => "${zookeeper::params::user}",
      group => "${zookeeper::params::group}",
      mode => '644',
      require => File["/data/0/"]
      }  
    }
    
    exec {"add-zookeeper-service":
    command => '/sbin/chkconfig --add zookeeper-server',
     refreshonly => false,      
     require => File['/etc/init.d/zookeeper-server'],       
      }

    service {'zookeeper':
    #ensure => running,
   # enable => true,
    hasstatus => true,
    hasrestart => true,
   }             
         
         }