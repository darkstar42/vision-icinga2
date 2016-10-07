require 'spec_helper'
require 'hiera'

describe 'vision_icinga2' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
                      :root_home => '/root'
                    })
      end

      before(:each) do
        Puppet::Parser::Functions.newfunction(:query_resources,
                                              :type => :rvalue) { |args|
          return []
        }
      end

      let(:params) {{
                      :parent_zone => 'localhost.localhost',
                      :type => 'client',
                    }}

      context 'compile' do
        it { is_expected.to compile }
        it { is_expected.to contain_user('nagios') }
        it { is_expected.to contain_user('icinga') }
      end

    end
  end
end
