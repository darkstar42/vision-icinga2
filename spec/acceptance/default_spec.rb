require 'spec_helper_acceptance'

describe 'PROFILE_NAME' do

  context 'with defaults' do
    it 'should idempotently run' do
      pp = <<-EOS
        class { 'PROFILE_NAME': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

  end

end
