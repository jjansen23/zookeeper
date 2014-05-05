# spec/classes/init_spec.rb
require 'spec_helper'

describe "zookeeper" do

  context "CentOS" do
    let :facts do
      {
         :osfamily              => 'RedHat',
         :operatingsystem => 'CentOS'
      }
    end    
end 
  
  it { should contain_class('zookeeper::params') }
  
   it { should create_file('/usr/local/zookeeper-3.3.6.tar.gz').with(
    	:ensure             => 'present',
      	:mode              => "640",
		) }

 it { should contain_exec('remove_zookeeper').with(
            'command'     => '/bin/rm -rf /opt/zookeeper',
            'refreshonly'    => 'false'
        ) }
      
    it { should contain_exec('untar_zookeeper').with(
            'command'     => '/bin/tar -xzvf /usr/local/zookeeper-3.3.6.tar.gz',
            'refreshonly'   => 'false',
            'require'         => 'Exec[remove_zookeeper]'
        ) }

    it { should contain_exec('rename_zookeeper').with(
            'command'     => '/bin/mv /opt/zookeeper-3.3.6 /opt/zookeeper',
            'refreshonly'   => 'false',
            'require'         => 'Exec[untar_zookeeper]'
        ) }

    it { should contain_exec('change_zk_owner').with(
            'command'    => '/bin/chown -R hduser:hadoop /opt/zookeeper',
            'refreshonly'  => 'false',
            'require'        => 'Exec[rename_zookeeper]'
        ) }
        
   it { should create_file('/opt/zookeeper/conf/zoo.cfg').with(
      	:owner              => "hduser",
    	:group              => "hadoop",
      	:mode              => "644",
      	:alias                 => "zoo.cfg"
		) }
		
 it { should create_file('/tmp/zookeeper').with(
        :ensure             => 'directory',
      	:owner              => "hduser",
    	:group              => "hadoop",
      	:mode              => "644",
		) }		
		    
it { should create_file('/etc/init.d/zookeeper').with(
        :ensure             => 'link',
        :target              => '/opt/zookeeper/bin/zkServer.sh',
      	:owner              => "hduser",
    	:group              => "hadoop",
      	:mode              => "644",
		) }		    
		       
end