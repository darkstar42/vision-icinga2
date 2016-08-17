require 'spec_helper_acceptance'

describe 'vision_icinga2' do
  context 'client with defaults' do
    it 'should idempotently run' do

      pp = <<-EOS
       class { 'vision_icinga2::client':
          parent_zone => 'foobar.de',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

  end

end
