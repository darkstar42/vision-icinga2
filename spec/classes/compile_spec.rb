require 'spec_helper'
require 'hiera'

describe 'vision_icinga2::client' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      before(:each) do
        Puppet::Parser::Functions.newfunction(:query_resources,
                                              :type => :rvalue) { |args|
          return []
        }
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end

    end
  end
end
