#
# A puppet site file for a CollectionSpace server
#

include cspace_environment::env
include cspace_environment::execpaths
include cspace_environment::osfamily
include cspace_environment::tempdir

# ---------------------------------------------------------
# Instantiate resources for creating or maintaining a
# CollectionSpace server instance
# ---------------------------------------------------------

# Instantiate the relevant classes and other resources for
# a CollectionSpace server instance, based on OS family.
#
# (We can add resources to be instantiated under the 'case' for each OS family,
# as they've been tested under at least one instance of that family.)

$os_family = $cspace_environment::osfamily::os_family
$cspace_env_vars = $cspace_environment::env::cspace_env_vars
$linux_exec_paths = $cspace_environment::execpaths::linux_default_exec_paths
$osx_exec_paths = $cspace_environment::execpaths::osx_default_exec_paths

case $os_family {
  
  # Supported Linux OS families
  RedHat: {
    class { 'cspace_server_dependencies': 
    }
    class { 'cspace_java': 
      require => Class[ 'cspace_server_dependencies' ]
    }
    class { 'cspace_postgresql_server':
      require => Class[ 'cspace_java' ]
    }
    class { 'cspace_tarball':
      require => Class[ 'cspace_java' ]
    }
    class { 'cspace_source':
      env_vars   => $cspace_env_vars,
      exec_paths => $linux_exec_paths,
      require    => Class[ 'cspace_tarball' ]
    }
  }
  Debian: {
    class { 'cspace_server_dependencies': }
    ->
    class { 'cspace_java': }
    ->
    class { 'cspace_postgresql_server': }
    ->
    class { 'cspace_tarball': }
    ->
    class { 'cspace_source':
      env_vars   => $cspace_env_vars,
      exec_paths => $linux_exec_paths
    }
  }
  
  # OS X
  darwin: {
    # class { 'cspace_server_dependencies': }
    # ->
    # class { 'cspace_java': }
    # ->
    # class { 'cspace_postgresql_server': }
    # ->
    class { 'cspace_tarball': }
    ->
    class { 'cspace_source':
      env_vars   => $cspace_env_vars,
      exec_paths => $osx_exec_paths
    }
  }
  
  # Microsoft Windows
  windows: {
    # class { 'cspace_server_dependencies': }
    # ->
    # class { 'cspace_java': }
    # ->
    # class { 'cspace_postgresql_server': }
    # ->
    # class { 'cspace_tarball': }
    # ->
    # class { 'cspace_source': }
  }
  
  default: {
  }
  
}





