#
# A puppet site file for a CollectionSpace server
#

include cspace_environment::execpaths
include cspace_environment::osbits
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

case $os_family {
  
  # Supported Linux OS families
  RedHat, Debian: {
    class { 'cspace_server_dependencies': 
    } ->
    class { 'cspace_java': 
    }
    # Remaining classes in the installation sequence here have been moved
    # to the 'post-java.pp' manifest
  }
  
  # OS X
  darwin: {
    # class { 'cspace_server_dependencies': }
    # ->
    # class { 'cspace_java': }
    # Remaining classes in the installation sequence here have been moved
    # to the 'post-java.pp' manifest
  }
  
  # Microsoft Windows
  windows: {
    # class { 'cspace_server_dependencies': }
    # ->
    # class { 'cspace_java': }
    # Remaining classes in the installation sequence here have been moved
    # to the 'post-java.pp' manifest
  }
  
  default: {
  }
  
}





