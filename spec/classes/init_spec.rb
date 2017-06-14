require 'spec_helper'

describe 'postfixadmin', :type => :class do
  let(:title) { 'postfixadmin' }
  let(:facts) { {:concat_basedir => '/path/to/dir'} }
  let(:current_version) { '3.0.2' }
  let(:archive_name) { "postfixadmin-#{current_version}" }
  let(:install_dir) { "/opt/postfixadmin-#{current_version}" }
  let(:config_file) { "#{install_dir}/config.local.php" }
  let(:config_file_header) { "#{config_file}__header" }
  let(:config_file_options_fragment) { "#{config_file}__options" }
  let(:installer) { "#{install_dir}/installer" }
  let(:logs) { "#{install_dir}/logs" }
  let(:temp) { "#{install_dir}/temp" }

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        # context "postfixadmin class without any parameters" do
        context 'with_manage_dirs => true' do

          let(:params) {
            {
              :manage_dirs => true
            }
          }

          it { is_expected.to contain_file('/opt').with({
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0755',
          }) }

          it { is_expected.to contain_file('/var/cache/puppet').with({
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0755',
          }) }

          it { is_expected.to contain_file('/var/cache/puppet/archives').with({
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0755',
          }) }

          specify { should contain_archive(archive_name) }

          it { is_expected.to contain_file(installer).with({
            'ensure'  => 'absent',
            'purge'   => true,
            'recurse' => true,
            'force'   => true,
            'backup'  => false,
          }) }

          it { is_expected.to contain_file(logs).with({
            'ensure' => 'directory',
            'mode'   => '0640',
          }) }

          it { is_expected.to contain_file(temp).with({
            'ensure' => 'directory',
            'mode'   => '0640',
          }) }

          it { is_expected.to contain_concat(config_file) }
          it { should contain_concat__fragment(config_file_header) }

          it { is_expected.to contain_concat__fragment(config_file_options_fragment).with_content(
              "$CONF['configured'] = false;\n$CONF['database_host'] = 'localhost';\n$CONF['database_name'] = 'postfix';\n$CONF['database_password'] = 'postfix';\n$CONF['database_type'] = 'mysqli';\n$CONF['database_user'] = 'postfix';\n$CONF['encrypt'] = 'dovecot:SHA512-CRYPT';\n"
            ) }

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('postfixadmin::params') }
          it { is_expected.to contain_class('postfixadmin::install').that_comes_before('postfixadmin::config') }
          it { is_expected.to contain_class('postfixadmin::config') }
          # it { is_expected.to contain_class('postfixadmin::service').that_subscribes_to('postfixadmin::config') }

          # it { is_expected.to contain_service('postfixadmin') }
          # it { is_expected.to contain_package('postfixadmin').with_ensure('present') }
        end
      end
    end
  end

  # context 'unsupported operating system' do
    # describe 'postfixadmin class without any parameters on Solaris/Nexenta' do
      # let(:facts) do
        # {
          # :osfamily        => 'Solaris',
          # :operatingsystem => 'Nexenta',
        # }
      # end

      # it { expect { is_expected.to contain_package('postfixadmin') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    # end
  # end
end
