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

  $configured           = false,

  $db_type              = 'mysqli',
  $db_host              = 'localhost',
  $db_user              = 'postfix',
  $db_pass              = 'postfix',
  $db_name              = 'postfix',
  $encrypt              = 'dovecot:SHA512-CRYPT',
  $config_file_template = undef,
  $options_hash         = {},
) inherits postfixadmin::params {
  validate_string($version)
  validate_string($checksum)
  validate_string($checksum_type)
  validate_string($archive_provider)
  validate_bool($manage_dirs)
  validate_bool($manage_user)
  validate_absolute_path($puppet_cache)
  validate_absolute_path($archive_dir)
  validate_absolute_path($install_dir)
  validate_string($process)
  validate_bool($configured)
  validate_string($db_type)
  validate_string($db_host)
  validate_string($db_user)
  validate_string($db_pass)
  validate_string($db_name)
  validate_string($encrypt)
  validate_hash($options_hash)

  class { '::postfixadmin::install': }
  -> class { '::postfixadmin::config': }
}
