# Class: postfixadmin::install
#
# Install the postfixadmin software package.
#
class postfixadmin::install inherits postfixadmin {

  $archive = "postfixadmin-${postfixadmin::version}"
  $target = "${postfixadmin::install_dir}/postfixadmin-${postfixadmin::version}"
  $download_url = "https://sourceforge.net/projects/postfixadmin/files/postfixadmin/postfixadmin-${postfixadmin::version}/${archive}.tar.gz"

  if $postfixadmin::manage_dirs {
    # $dir_dependencies = [ '/var/cache/puppet', $postfixadmin::package_dir, $postfixadmin::install_dir  ]

    file { $postfixadmin::install_dir:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    file { $postfixadmin::package_dir:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    file { '/var/cache/puppet':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  case $postfixadmin::archive_provider {
    'nanliu', 'puppet': {
      archive { "${postfixadmin::package_dir}/${archive}.tar.gz":
        ensure        => present,
        checksum      => $postfixadmin::checksum,
        checksum_type => $postfixadmin::checksum_type,
        source        => $download_url,
        extract_path  => $postfixadmin::install_dir,
        creates       => "${postfixadmin::package_dir}/${archive}.tar.gz",
        extract       => true,
        cleanup       => false,
        extract_flags => '-x --no-same-owner -f',
        require       => [
          File[$postfixadmin::install_dir],
          File[$postfixadmin::package_dir]
        ],
      }
      $require_archive = Archive["${postfixadmin::package_dir}/${archive}.tar.gz"]
    }
    'camptocamp': {
      archive { $archive:
        ensure           => present,
        digest_string    => $postfixadmin::checksum,
        digest_type      => $postfixadmin::checksum_type,
        url              => $download_url,
        follow_redirects => true,
        target           => $postfixadmin::install_dir,
        src_target       => $postfixadmin::package_dir,
        root_dir         => "postfixadmin-${postfixadmin::version}",
        timeout          => 600,
        require          => [
          File[$postfixadmin::install_dir],
          File[$postfixadmin::package_dir]
        ],
      }
      $require_archive = Archive[$archive]
    }
    default: {
      fail("Unsupported \$archive_provider '${postfixadmin::archive_provider}'. Should be 'camptocamp' or 'nanliu' (aka 'puppet').")
    }
  }

  file { ["${target}/logs", "${target}/temp"]:
    ensure  => directory,
    owner   => $postfixadmin::process,
    group   => $postfixadmin::process,
    mode    => '0640',
    require => $require_archive,
  }

  file { "${target}/installer":
    ensure  => absent,
    purge   => true,
    recurse => true,
    force   => true,
    backup  => false,
    require => $require_archive,
  }

}
