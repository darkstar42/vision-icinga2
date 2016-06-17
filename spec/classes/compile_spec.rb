require 'spec_helper'

describe 'PROFILE_NAME' do

  let(:facts) {{
                 :osfamily => 'Debian',
               }}

  context 'compile' do
    it { is_expected.to compile.with_all_deps }
  end

end
