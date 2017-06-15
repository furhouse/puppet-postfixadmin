# == Class: postfixadmin::params
#
# Default configuration values for the `postfixadmin` class.
#
class postfixadmin::params {
  $version = '3.0.2'
  $checksum = '9a4edb111258c90912aea66ad1dd684445b4f03f08f8549b9d708336ae019c8c'
  $checksum_type = 'sha256'

  $archive_provider = 'camptocamp'

  $manage_dirs  = false
  $manage_user  = true
  $puppet_cache = '/var/cache/puppet'
  $archive_dir  = '/var/cache/puppet/archives'
  $install_dir  = '/opt'

  $document_root_manage = true
  $document_root = '/var/www/postfixadminmail'
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

  $exec_paths = ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin']
}
