require 'spec_helper'

describe 'postfixadmin', :type => :class do
  let(:title) { 'postfixadmin' }
  let(:facts) { {:concat_basedir => '/path/to/dir'} }
  let(:current_version) { '3.0.2' }
  let(:puppet_cache) { '/var/cache/puppet' }
  let(:archive_dir) { '/var/cache/puppet/archives' }
  let(:archive_name) { "postfixadmin-#{current_version}" }
  let(:install_top_dir) { '/opt' }
  let(:install_dir) { "/opt/postfixadmin-#{current_version}" }
  let(:installer) { "#{install_dir}/installer" }
  let(:logs_dir) { "#{install_dir}/logs" }
  let(:temp_dir) { "#{install_dir}/temp" }
  let(:config_file) { "#{install_dir}/config.local.php" }
  let(:config_file_header) { "#{config_file}__header" }
  let(:config_file_options_fragment) { "#{config_file}__options" }

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'with_manage_dirs => true' do

          let(:params) {
            {
              :manage_dirs => true
            }
          }

          it { is_expected.to contain_file(install_top_dir).with({
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0755',
          }) }

          it { is_expected.to contain_file(puppet_cache).with({
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0755',
          }) }

          it { is_expected.to contain_file(archive_dir).with({
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

          if os == 'debian-8-x86_64'
            it { is_expected.to contain_file(logs_dir).with({
              'ensure' => 'directory',
              'owner'  => 'www-data',
              'group'  => 'www-data',
              'mode'   => '0640',
            }) }

          it { is_expected.to contain_file(temp_dir).with({
            'ensure' => 'directory',
            'owner'  => 'www-data',
            'group'  => 'www-data',
            'mode'   => '0640',
          }) }

          elsif os == 'redhat-7-x86_64'
            it { is_expected.to contain_file(logs_dir).with({
              'ensure' => 'directory',
              'owner'  => 'httpd',
              'group'  => 'httpd',
              'mode'   => '0640',
            }) }

          it { is_expected.to contain_file(temp_dir).with({
            'ensure' => 'directory',
            'owner'  => 'httpd',
            'group'  => 'httpd',
            'mode'   => '0640',
          }) }
          end

          it { is_expected.to contain_concat(config_file) }
          it { should contain_concat__fragment(config_file_header) }
          it { is_expected.to contain_concat__fragment(config_file_options_fragment).with_content(
              "$CONF['configured'] = false;\n$CONF['database_host'] = 'localhost';\n$CONF['database_name'] = 'postfix';\n$CONF['database_password'] = 'postfix';\n$CONF['database_type'] = 'mysqli';\n$CONF['database_user'] = 'postfix';\n$CONF['encrypt'] = 'dovecot:SHA512-CRYPT';\n"
            ) }

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('postfixadmin::params') }
          it { is_expected.to contain_class('postfixadmin::install').that_comes_before('postfixadmin::config') }
          it { is_expected.to contain_class('postfixadmin::config') }
        end
      end
    end
  end

end
