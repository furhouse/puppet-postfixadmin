require 'spec_helper'

describe 'postfixadmin' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "postfixadmin class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('postfixadmin::params') }
          it { is_expected.to contain_class('postfixadmin::install').that_comes_before('postfixadmin::config') }
          it { is_expected.to contain_class('postfixadmin::config') }
          it { is_expected.to contain_class('postfixadmin::service').that_subscribes_to('postfixadmin::config') }

          it { is_expected.to contain_service('postfixadmin') }
          it { is_expected.to contain_package('postfixadmin').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'postfixadmin class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('postfixadmin') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
