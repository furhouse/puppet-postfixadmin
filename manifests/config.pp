# Class: postfixadmin::config
#
# Manage the postfixadmin configuration files.
#
#
class postfixadmin::config inherits postfixadmin {

  $application_dir = $postfixadmin::install::target
  $config_file = "${application_dir}/config.local.php"

  $options_defaults = {
    'configured'        => $postfixadmin::configured,
    'database_type'     => $postfixadmin::db_type,
    'database_host'     => $postfixadmin::db_host,
    'database_user'     => $postfixadmin::db_user,
    'database_password' => $postfixadmin::db_pass,
    'database_name'     => $postfixadmin::db_name,
    'encrypt'           => $postfixadmin::encrypt,
  }

  $options = merge($options_defaults, $postfixadmin::options_hash)

  concat { $config_file:
    owner => $postfixadmin::process,
    group => $postfixadmin::process,
    mode  => '0440',
  }

  Concat::Fragment {
    target  => $config_file,
  }

  if empty($postfixadmin::config_file_template) {
    concat::fragment { "${config_file}__header":
      content => template('postfixadmin/config/header.php.erb'),
      order   => '10',
    }

    if !empty($options) {
      concat::fragment { "${config_file}__options":
        content => template('postfixadmin/config/options.php.erb'),
        order   => '20',
      }
    }
  }
  else {
    concat::fragment { "${config_file}__header":
      content => template($postfixadmin::config_file_template),
      order   => '10',
    }
  }

  cron { 'postfixadmin-cleandb':
    ensure  => present,
    command => "${application_dir}/bin/cleandb.sh > /dev/null",
    user    => 'root',
    hour    => fqdn_rand(24),
    minute  => fqdn_rand(60),
  }
}
