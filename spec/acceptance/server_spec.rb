require 'spec_helper_acceptance'

describe 'vision_icinga2_server' do
  context 'server with defaults' do
    it 'should idempotently run' do

      pp = <<-EOS

       # MOCKING STUFF
        class vision_mysql::server::phpmyadmin::client(
            String $server,
            String $role,
        ) {}

        file { ['/vision','/vision/pki']:
            ensure => directory
        }->
        file { "/vision/pki/${::fqdn}.crt":
            ensure => link,
            target => '/tmp/dummycert.crt',
        }->
        file { "/vision/pki/${::fqdn}.key":
            ensure  => link,
            target  => '/tmp/dummycert.key',
        }->
        file { '/vision/pki/VisionCA.crt':
            ensure  => link,
            target => '/tmp/dummyCA.pem',
       }->
       class { 'vision_icinga2':
          type => 'server',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)

    end

    context 'package installed' do
      describe package('icinga2') do
        it { should be_installed }
      end

      describe package('icinga2-common') do
        it { should be_installed }
      end

      describe package('icinga2-ido-mysql') do
        it { should be_installed }
      end

      describe port(5665) do
        it { should be_listening }
      end
    end


    context 'mysql isntalled' do
      describe command('mysql -e "select user from mysql.user"') do
        its(:exit_status) { is_expected.to eq 0 }
        its(:stdout) { is_expected.to contain 'icinga2' }
      end

      describe command('mysql -e "show databases"') do
        its(:exit_status) { is_expected.to eq 0 }
        its(:stdout) { is_expected.to contain 'icinga2' }
      end

      describe port(3306) do
        it { should be_listening }
      end
    end

    context 'config provisioned' do
      describe file('/etc/icinga2/features-enabled/ido-mysql.conf') do
        it { should be_file }
        its(:content) { should match 'host = "localhost"' }
        its(:content) { should match 'port = 3306' }
        its(:content) { should match 'user = "icinga2"' }
        its(:content) { should match 'password = "icinga2"' }
        its(:content) { should match 'database = "icinga2"' }
      end

      describe file('/etc/icinga2/objects/apiusers/icinga2.conf') do
        it { should be_file }
        its(:content) { should match 'password = "icinga2"' }
      end

      describe file('/etc/icinga2/objects/users/vision-it.conf') do
        it { should be_file }
        its(:content) { should match 'vision-sysadmin' }
      end

      describe file('/etc/icinga2/objects/usergroups/vision-sysadmin.conf') do
        it { should be_file }
        its(:content) { should match 'vision-sysadmin' }
      end

      # Commented out until Icinga works properly

      # describe file('/etc/icinga2/objects/notificationcommands/slack-service-notification.conf') do
      #   it { should be_file }
      #   its(:content) { should match '/icinga2/scripts/slack-service-notification.sh' }
      # end

      # describe file('/etc/icinga2/scripts/slack-service-notification.sh') do
      #   it { should contain 'SLACK_CHANNEL="#monitoring"' }
      #   it { should contain 'SLACK_WEBHOOK_URL="foobar"' }
      # end


    end

  end
end
