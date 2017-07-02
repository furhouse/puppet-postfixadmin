# == Class: postfixadmin
#
# Full description of class postfixadmin here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'postfixadmin':
#    options_hash => {
#      'admin_email' => 'admin@example.com',
#    }
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class postfixadmin (
  $version              = $postfixadmin::params::version,
  $checksum             = $postfixadmin::params::checksum,
  $checksum_type        = $postfixadmin::params::checksum_type,
  $archive_provider     = $postfixadmin::params::archive_provider,
  $manage_dirs          = $postfixadmin::params::manage_dirs,
  $manage_user          = $postfixadmin::params::manage_user,
  $puppet_cache         = $postfixadmin::params::puppet_cache,
  $archive_dir          = $postfixadmin::params::archive_dir,
  $install_dir          = $postfixadmin::params::install_dir,
  $process              = $postfixadmin::params::process,
  $configured           = $postfixadmin::params::configured,
  $db_type              = $postfixadmin::params::db_type,
  $db_host              = $postfixadmin::params::db_host,
  $db_user              = $postfixadmin::params::db_user,
  $db_pass              = $postfixadmin::params::db_pass,
  $db_name              = $postfixadmin::params::db_name,
  $encrypt              = $postfixadmin::params::encrypt,
  $config_file_template = $postfixadmin::params::config_file_template,
  $custom_functions     = $postfixadmin::params::custom_functions,
  $options_hash         = $postfixadmin::params::options_hash,
) inherits postfixadmin::params {
  validate_string($version,$checksum,$checksum_type,$archive_provider,$config_file_template)
  validate_string($custom_functions,$process,$db_type,$db_host,$db_user,$db_pass,$db_name,$encrypt)
  validate_bool($manage_dirs,$manage_user,$configured)
  validate_absolute_path($puppet_cache,$archive_dir,$install_dir)
  validate_hash($options_hash)

  class { '::postfixadmin::install': }
  -> class { '::postfixadmin::config': }
}
