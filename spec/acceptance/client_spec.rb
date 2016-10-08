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
       class { 'vision_icinga2':
          parent_zone => 'foobar.de',
          client_zone => 'debian-8-x64',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'package installed' do
    describe package('icinga2') do
      it { should be_installed }
    end

    describe package('icinga2-common') do
      it { should be_installed }
    end

    describe file('/etc/apt/sources.list.d/debmon.list') do
      it { should be_file }
    end
  end

  context 'plugins directory' do
    describe file('/usr/lib/nagios/plugins') do
      it { should be_directory }
    end
  end

  context 'config provisioned' do
    describe file('/etc/icinga2/objects/hosts/debian-8-x64.conf') do
      it { should be_file }
      its(:content) { should match '"parent" = "foobar.de"' }
      its(:content) { should match 'Host "debian-8-x64"' }
    end

    describe file('/etc/icinga2/features-available/api.conf') do
      it { should be_file }
      its(:content) { should match '/vision/pki/debian-8-x64' }
      its(:content) { should match '/vision/pki/VisionCA.crt' }
    end

    describe group('icinga') do
      it { should exist }
    end
    describe group('monitor') do
      it { should exist }
    end
    describe group('storage') do
      it { should exist }
    end
    describe group('ssl-cert') do
      it { should exist }
    end


    describe file('/etc/icinga2/objects/checkcommands/vision-backupage.conf') do
      it { should be_file }
      its(:content) { should match 'vision-backupage' }
    end

    describe file('/etc/icinga2/objects/checkcommands/vision-mysql.conf') do
      it { should be_file }
      its(:content) { should match 'vision-mysql' }
    end

    describe file('/etc/icinga2/objects/applys/exim.conf') do
      it { should be_file }
      its(:content) { should match 'vision-mailq' }
    end

    describe file('/etc/icinga2/objects/applys/mail-host-notification.conf') do
      it { should be_file }
      its(:content) { should match 'vision-sysadmin' }
    end
  end

end
