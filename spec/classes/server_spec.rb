require 'spec_helper'
require 'hiera'

describe 'vision_icinga2::server' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      before(:each) do
        # mock all query_resource calls
        Puppet::Parser::Functions.newfunction(:query_resources,
                                              :type => :rvalue) { |args|
          return []
        }
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_user('nagios') }
        it { is_expected.to contain_user('icinga') }
      end

    end
  end
end
