require 'spec_helper'

describe 'postfixadmin', :type => :class do
  let(:title) { 'postfixadmin' }
  let(:rhel_user) { 'postfixadmin' }
  let(:facts) { {:concat_basedir => '/path/to/dir'} }
  let(:current_version) { '3.1' }
  let(:puppet_cache) { '/var/cache/puppet' }
  let(:archive_dir) { '/var/cache/puppet/archives' }
  let(:archive_name) { "postfixadmin-#{current_version}" }
  let(:install_top_dir) { '/opt' }
  let(:install_dir) { "/opt/postfixadmin-#{current_version}" }
  let(:installer) { "#{install_dir}/installer" }
  let(:logs_dir) { "#{install_dir}/logs" }
  let(:temp_dir) { "#{install_dir}/temp" }
  let(:templates_c_dir) { "#{install_dir}/templates_c" }
  let(:config_file) { "#{install_dir}/config.local.php" }
  let(:config_file_header) { "#{config_file}__header" }
  let(:config_file_options_fragment) { "#{config_file}__options" }

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge(super())
        end

        context 'with_manage_dirs => true' do
          let(:params) { { :manage_dirs => true } }

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('postfixadmin::params') }

          describe "postfix::install" do
            it { is_expected.to contain_class('postfixadmin::install') }

            it { should contain_file(puppet_cache).with_ensure('directory') }
            it { should contain_file(puppet_cache).with_owner('root') }
            it { should contain_file(puppet_cache).with_group('root') }
            it { should contain_file(puppet_cache).with_mode('0755') }

            it { should contain_file(install_top_dir).with_ensure('directory') }
            it { should contain_file(install_top_dir).with_owner('root') }
            it { should contain_file(install_top_dir).with_group('root') }
            it { should contain_file(install_top_dir).with_mode('0755') }

            it { should contain_file(archive_dir).with_ensure('directory') }
            it { should contain_file(archive_dir).with_owner('root') }
            it { should contain_file(archive_dir).with_group('root') }
            it { should contain_file(archive_dir).with_mode('0755') }

            specify { should contain_archive(archive_name) }

            it { should contain_file(installer).with_ensure('absent') }
            it { should contain_file(installer).with_purge(true) }
            it { should contain_file(installer).with_recurse(true) }
            it { should contain_file(installer).with_force(true) }
            it { should contain_file(installer).with_purge(true) }

            if facts[:os]['family'] == 'Debian'
              it { should contain_file(logs_dir).with_ensure('directory') }
              it { should contain_file(logs_dir).with_owner('www-data') }
              it { should contain_file(logs_dir).with_group('www-data') }
              it { should contain_file(logs_dir).with_mode('0640') }

              it { should contain_file(temp_dir).with_ensure('directory') }
              it { should contain_file(temp_dir).with_owner('www-data') }
              it { should contain_file(temp_dir).with_group('www-data') }
              it { should contain_file(temp_dir).with_mode('0640') }

              it { should contain_file(templates_c_dir).with_ensure('directory') }
              it { should contain_file(templates_c_dir).with_owner('www-data') }
              it { should contain_file(templates_c_dir).with_group('www-data') }
              it { should contain_file(templates_c_dir).with_mode('0640') }

            elsif facts[:os]['family'] == 'RedHat'
              it { should contain_group(rhel_user).with_ensure('present') }
              it { should contain_group(rhel_user).with_system(true) }

              it { should contain_user(rhel_user).with_ensure('present') }
              it { should contain_user(rhel_user).with_shell('/sbin/nologin') }
              it { should contain_user(rhel_user).with_home(install_dir) }
              it { should contain_user(rhel_user).with_gid(rhel_user) }
              it { should contain_user(rhel_user).with_managehome(true) }
              it { should contain_user(rhel_user).with_system(true) }

              it { should contain_file(logs_dir).with_ensure('directory') }
              it { should contain_file(logs_dir).with_owner(rhel_user) }
              it { should contain_file(logs_dir).with_group(rhel_user) }
              it { should contain_file(logs_dir).with_mode('0640') }

              it { should contain_file(temp_dir).with_ensure('directory') }
              it { should contain_file(temp_dir).with_owner(rhel_user) }
              it { should contain_file(temp_dir).with_group(rhel_user) }
              it { should contain_file(temp_dir).with_mode('0640') }

              it { should contain_file(templates_c_dir).with_ensure('directory') }
              it { should contain_file(templates_c_dir).with_owner(rhel_user) }
              it { should contain_file(templates_c_dir).with_group(rhel_user) }
              it { should contain_file(templates_c_dir).with_mode('0640') }
            end
          end

          describe "postfix::config" do
            it { is_expected.to contain_class('postfixadmin::config') }
            it { is_expected.to contain_concat(config_file) }
            it { should contain_concat__fragment(config_file_header) }
            it { is_expected.to contain_concat__fragment(config_file_options_fragment).with_content( "$CONF['configured'] = false;\n$CONF['database_host'] = 'localhost';\n$CONF['database_name'] = 'postfix';\n$CONF['database_password'] = 'postfix';\n$CONF['database_type'] = 'mysqli';\n$CONF['database_user'] = 'postfix';\n$CONF['encrypt'] = 'dovecot:SHA512-CRYPT';\n") }
          end
        end
      end
    end
  end
end
