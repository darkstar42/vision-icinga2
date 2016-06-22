require 'spec_helper_acceptance'

describe 'vision_skeleton' do

  context 'with defaults' do
    it 'should idempotently run' do
      pp = <<-EOS
        class { 'vision_skeleton': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

  end

end
