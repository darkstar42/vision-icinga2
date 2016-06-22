require 'spec_helper'

describe 'vision_skeleton' do

  let(:facts) {{
                 :osfamily => 'Debian',
               }}

  context 'compile' do
    it { is_expected.to compile.with_all_deps }
  end

end
