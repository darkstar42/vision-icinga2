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
          type                           => 'server',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)

    end

    context 'check provisioned files' do
      describe file('/etc/icinga2/scripts/slack-service-notification.sh') do
        it { should contain 'SLACK_CHANNEL="#monitoring"' }
        it { should contain 'SLACK_WEBHOOK_URL="foobar"' }
      end
    end

  end

end
