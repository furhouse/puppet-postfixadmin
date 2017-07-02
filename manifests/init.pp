# == Class: postfixadmin
#
# @summary Manages Postfix Admin, a web based administration interface for Postfix mail servers.
#
# @example Declaring the class
#   class { '::postfixadmin': manage_dirs => true }
#
# @param version [String] Sets the version of Postfix Admin.
#
# @param checksum [String] Sets the checksum type, required for validating the Postfix Admin tarfile.
#
# @param checksum_type [String] Sets the checksum method, required for validating the Postfix Admin tarfile.
#
# @param archive_provider [String] Sets the archive_provider, required for downloading and extracting the Postfix Admin tarfile.
#
# @param manage_dirs [Boolean] Whether to manage the parent directories install_dir and puppet_cache.
#
# @param manage_user [Boolean] Whether to manage a system user and group, for ownership of install_dir/{logs,temp,config.local.php}.
#
# @param puppet_cache [Stdlib::Absolutepath] Sets the parent directory for the files downloaded by the archive_provider.
#
# @param archive_dir [Stdlib::Absolutepath] Sets the directory which contains the files downloaded by the archive_provider.
#
# @param install_dir [Stdlib::Absolutepath] Sets the parent directory for the Postfix Admin installation.
#
# @param process [String] Sets the user and group of the Postfix Admin web application.
#
# @param configured [Boolean] Enables the use of the Postfix Admin web application.
#
# @param db_type [String] Sets the type of the Postfix Admin database.
#
# @param db_host [String] Sets the host of the Postfix Admin database.
#
# @param db_user [String] Sets the user of the Postfix Admin database.
#
# @param db_pass [String] Sets the pass of the Postfix Admin database.
#
# @param db_name [String] Sets the name of the Postfix Admin database.
#
# @param encrypt [String] Sets the way passwords are encrypted.
#
# @param options_hash Optional[Hash] You can configure other parameters by passing a hash to options_hash.
#
# @param custom_config_file [Optional[String]] Provide your own config, from a file.
#
# @param custom_functions_file [Optional[String]] Provide your own Postfix Admin functions, from a file.
#
class postfixadmin (
  $version               = $postfixadmin::params::version,
  $checksum              = $postfixadmin::params::checksum,
  $checksum_type         = $postfixadmin::params::checksum_type,
  $archive_provider      = $postfixadmin::params::archive_provider,
  $manage_dirs           = $postfixadmin::params::manage_dirs,
  $manage_user           = $postfixadmin::params::manage_user,
  $puppet_cache          = $postfixadmin::params::puppet_cache,
  $archive_dir           = $postfixadmin::params::archive_dir,
  $install_dir           = $postfixadmin::params::install_dir,
  $process               = $postfixadmin::params::process,
  $configured            = $postfixadmin::params::configured,
  $db_type               = $postfixadmin::params::db_type,
  $db_host               = $postfixadmin::params::db_host,
  $db_user               = $postfixadmin::params::db_user,
  $db_pass               = $postfixadmin::params::db_pass,
  $db_name               = $postfixadmin::params::db_name,
  $encrypt               = $postfixadmin::params::encrypt,
  $custom_config_file    = $postfixadmin::params::custom_config_file,
  $custom_functions_file = $postfixadmin::params::custom_functions_file,
  $options_hash          = $postfixadmin::params::options_hash,
) inherits postfixadmin::params {
  validate_string($version,$checksum,$checksum_type,$archive_provider,$custom_config_file)
  validate_string($custom_functions_file,$process,$db_type,$db_host,$db_user,$db_pass,$db_name,$encrypt)
  validate_bool($manage_dirs,$manage_user,$configured)
  validate_absolute_path($puppet_cache,$archive_dir,$install_dir)
  validate_hash($options_hash)

  class { '::postfixadmin::install': }
  -> class { '::postfixadmin::config': }
}
