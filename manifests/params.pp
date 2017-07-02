# == Class: postfixadmin::params
#
# Default configuration values for the `postfixadmin` class.
#
class postfixadmin::params {
  $version              = '3.1'
  $checksum             = '36eaed433c673382fb5d513bc3b0d2685bf3169ead6065293d3a0f8f6d262aa4'
  $checksum_type        = 'sha256'
  $archive_provider     = 'camptocamp'
  $manage_dirs          = false
  $manage_user          = true
  $puppet_cache         = '/var/cache/puppet'
  $archive_dir          = "${puppet_cache}/archives"
  $install_dir          = '/opt'
  $configured           = false
  $db_type              = 'mysqli'
  $db_host              = 'localhost'
  $db_user              = 'postfix'
  $db_pass              = 'postfix'
  $db_name              = 'postfix'
  $encrypt              = 'dovecot:SHA512-CRYPT'
  $config_file_template = undef
  $custom_functions     = undef
  $options_hash         = {}

  case $::osfamily {
    'RedHat':  {
      $process = 'postfixadmin'
    }
    'Debian':  {
      $process = 'www-data'
    }
    default: {
      fail("Unsupported \$process '${postfixadmin::process}', OS family: ${::osfamily}")
    }
  }

}
