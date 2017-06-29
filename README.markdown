[![Puppet Forge](https://img.shields.io/puppetforge/v/furhouse/postfixadmin.svg)](https://forge.puppet.com/furhouse/postfixadmin)
[![Build Status](https://travis-ci.org/furhouse/puppet-postfixadmin.svg?branch=master)](https://travis-ci.org/furhouse/puppet-postfixadmin)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with postfixadmin](#setup)
    * [What postfixadmin affects](#what-postfixadmin-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with postfixadmin](#beginning-with-postfixadmin)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [postfixadmin](#class-postfixadmin)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Todo](#todo)

## Overview

Downloads, installs and configures [Postfix Admin](http://postfixadmin.sourceforge.net/).

## Module Description

Postfix Admin provides a web interface to manage mailboxes, virtual domains and more. It requires PHP, Postfix and MySQL or PostgreSQL.

Besides a web interface, Postfix Admin also ships with a command line interface, [postfixadmin-cli](https://github.com/postfixadmin/postfixadmin/blob/master/scripts/postfixadmin-cli).

## Setup

### What postfixadmin affects

- Downloads, extracts and configures (but in a [disabled state](#configured)) Postfix Admin, version 3.0.2.
- Creates a [postfixadmin](#manage_user) user and group on Red Hat based distributions.
- Creates the parent directories for [postfixadmin](#manage_dirs) archive and extracted files.

### Setup Requirements

This module expect either [camptocamp-archive or puppet-archive](#archive_provider) to be installed. Neither are specified as dependency, but camptocamp-archive is the default.

By default, Postfix Admin will be extracted to [/var/cache/puppet/archive](#archive_dir) and installed in `/opt/postfixadmin-3.0.2`, based on the specified version. Both parent directories should exist (and can be managed by  setting [manage_dirs](#manage_dirs) to `true`).

### Beginning with postfixadmin

To simply install postfixadmin without any configuration, (don't really) use:

```
class { '::postfixadmin':
  manage_dirs => true,
  configured  => true,
}
```

## Usage

By default, postfixadmins' config.inc.php file loads config.local.php, which is the file this module manages. The bare minimum is provided, but can be easily expanded by passing a hash to [options_hash](#options_hash).

```
class { '::postfixadmin':
  manage_dirs  => true,
  configured   => true,
  db_type      => 'mysqli',
  db_host      => 'localhost',
  db_user      => 'postfix',
  db_pass      => 'postfix',
  db_name      => 'postfix',
  encrypt      => 'dovecot:SHA512-CRYPT',
  options_hash => {
    'admin_email'         => 'admin@example.com',
    'password_validation' => [
      "/.{5}/'            => 'password_too_short 5",
      "/([a-zA-Z].*){3}/' => 'password_no_characters 3",
    ],
  }
}
```

## Reference

### Class: `postfixadmin`

When this class is declared with the default options, Puppet:

- Downloads a postfixadmin archive, [version](#version), and extracts it to [install_dir](#install_dir)/[version](#version).
- Creates a new configuration file, `config.local.php`.
- Removes the installer directory from [install_dir](#install_dir)/[version](#version).
- Changes the owner and group of [install_dir](#install_dir)/[version](#version)`/{logs,temp,config.local.php}` to `www-data` on Debian based distributions, and to `postfixadmin` on RedHat and its derivatives.
- Creates a system owner and group on RedHat based distributions, based on [manage_user](#manage_user) and [process](#process).

If you would  just declare the default `postfixadmin` class, Postfix Admin will
be installed in a disabled state, since [configured](#configured) is set to
`false` by default.

**Parameters within `postfixadmin`:**

##### `version`

Sets the version of Postfix Admin. Default: `3.0.2`.

```
class { '::postfixadmin':
  version => '3.0.2',
}
```

##### `checksum`

Sets the checksum type, required for validating the Postfix Admin tarfile. Default: `9a4edb111258c90912aea66ad1dd684445b4f03f08f8549b9d708336ae019c8c`.

```
class { '::postfixadmin':
  checksum_type => '9a4edb111258c90912aea66ad1dd684445b4f03f08f8549b9d708336ae019c8c',
}
```

##### `checksum`

Sets the checksum method, required for validating the Postfix Admin tarfile. Default: `sha256`.

```
class { '::postfixadmin':
  checksum => 'sha256',
}
```

##### `archive_provider`

Sets the archive_provider, required for downloading and extracting the Postfix Admin tarfile. Default: `camptocamp`.

```
class { '::postfixadmin':
  archive_provider => 'camptocamp',
}
```

##### `manage_dirs`

Creates the parent directories for [install_dir](#install_dir) and [puppet_cache](#puppet_cache). Default: `false`.

```
class { '::postfixadmin':
  manage_dirs => false,
}
```

##### `manage_user`

Creates a system user and group, for ownership of [install_dir](#install_dir)`/{logs,temp,config.local.php}`. Default: `true` if `facts[:os]['family'] == 'RedHat'`.

```
class { '::postfixadmin':
  manage_user => false,
}
```

##### `puppet_cache`

Sets the parent directory for the files downloaded by [the archive_provider](#archive_provider). Default: `/var/cache/puppet`.

```
class { '::postfixadmin':
  puppet_cache => '/var/cache/puppet',
}
```

##### `archive_dir`

Sets the directory which contains the files downloaded by [the archive_provider](#archive_provider). Default: `/var/cache/puppet/archive`.

```
class { '::postfixadmin':
  archive_dir => '/var/cache/puppet/archive',
}
```

##### `install_dir`

Sets the parent directory for the Postfix Admin installation. Default: `/opt`.

```
class { '::postfixadmin':
  install_dir => '/opt',
}
```

##### `process`

Sets the user and group of the Postfix Admin web application. Default: Depends on your operating system.

- **Debian**: `www-data`
- **Red Hat**: `postfixadmin`

```
class { '::postfixadmin':
  process => 'www-data',
}
```

##### `configured`

Enables the use of the Postfix Admin web application. Default: `false`.

```
class { '::postfixadmin':
  configured => 'false',
}
```

##### `db_type`

Sets the type of the Postfix Admin database. Default: `mysqli`.

```
class { '::postfixadmin':
  db_type => 'mysqli',
}
```

##### `db_host`

Sets the host of the Postfix Admin database. Default: `localhost`.

```
class { '::postfixadmin':
  db_host => 'localhost',
}
```

##### `db_user`

Sets the user of the Postfix Admin database. Default: `postfix`.

```
class { '::postfixadmin':
  db_user => 'postfix',
}
```

##### `db_pass`

Sets the pass of the Postfix Admin database. Default: `postfix`.

```
class { '::postfixadmin':
  db_pass => 'postfix',
}
```

##### `db_name`

Sets the name of the Postfix Admin database. Default: `postfix`.

```
class { '::postfixadmin':
  db_name => 'postfix',
}
```

##### `encrypt`

Sets the way passwords are encrypted. Default: `dovecot:SHA512-CRYPT`.

```
class { '::postfixadmin':
  encrypt => 'dovecot:SHA512-CRYPT',
}
```

##### `options_hash`

You can configure other parameters by passing a hash to `options_hash`.
Default: `{}`.

See [config.inc.php](https://github.com/postfixadmin/postfixadmin/blob/master/config.inc.php) from the Postfix Admin github repository for a full reference.

```
class { '::postfixadmin':
  options_hash => {
    'admin_email'         => 'admin@example.com',
    'smtp_server'         => 'mail.example.com',
    'domain_path'         => 'NO',
    'domain_in_mailbox'   => 'NO',
    'password_validation' => [
      "/.{5}/'            => 'password_too_short 5",
      "/([a-zA-Z].*){3}/' => 'password_no_characters 3",
    ],
  }
}
```

##### `config_file_template`

You can use a template for creating the `config.local.php` file: Default: `undef`.

```
class { '::postfixadmin':
  config_file_template => 'postfixadmin/my_custom_template.erb',
}
```

`postfixadmin/templates/my_custom_template.erb`:

```
// Change the text between EOM.
$CONF['welcome_text'] = <<<EOM
Hi,

Welcome to your new account.
EOM;
```

##### `custom_functions`

You can use a file for adding custom functions to `config.local.php` file: Default: `undef`.

```
class { '::postfixadmin':
  custom_functions => 'postfixadmin/my_custom_function.txt',
}
```

`postfixadmin/files/my_custom_function.txt`:

```
function language_hook($PALANG, $language) {
    switch ($language) {
        case "de":
            $PALANG['x_whatever'] = 'foo';
            break;
        case "fr":
            $PALANG['x_whatever'] = 'bar';
            break;
        default:
            $PALANG['x_whatever'] = 'foobar';
    }
    return $PALANG;
}
```

## Limitations

- Requires manual seeding of database, ie `$ curl -v https://postfixadmin.example.com/setup.php`
- Does not manage a webserver.
- Does not manage a database.
- Does not manage PHP.
- Does not manage SELinux.
- This module is tested with ruby 2.1.8

## Development

This project uses rspec-puppet and beaker to ensure the module works as expected and to prevent regressions.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Todo

- Refactor for Puppet 4.
- Revisit `manage_dirs`.
- Expand travis ruby version.
- Automate seeding of database.
