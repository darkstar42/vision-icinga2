require 'spec_helper_acceptance'

describe 'vision_icinga2_server' do
  context 'server with defaults' do
    it 'should idempotently run' do

      pp = <<-EOS
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
       class { 'vision_icinga2::server':
          api_password                   => 'icinga2',
          mysql_password                 => 'icinga2',
          mysql_root_password            => 'icinga2',
          notification_users             => {},
          notification_groups            => {},
          notification_email             => 'foo@bar.de',
          notification_slack_webhook_url => 'barfoo.slack.com',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

  end

end
