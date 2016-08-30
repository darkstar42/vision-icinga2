require 'spec_helper_acceptance'

describe 'vision_icinga2_client' do
  context 'client with defaults' do
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
       class { 'vision_icinga2::client':
          parent_zone => 'foobar.de',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

  end

end
