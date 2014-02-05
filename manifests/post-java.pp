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
    # Continuation here from earlier classes in the installation sequence,
    # maintained in the 'site.pp' manifest.
    class { 'cspace_user::user':
    } ->
    class { 'cspace_postgresql_server':
    } ->
    class { 'cspace_tarball::globals':
      # Uncomment line below to set release version to a value other than
      # its current default value, '4.0'
      # release_version => "4.0"
    } ->
    class { 'cspace_tarball':
    } ->
    class { 'cspace_source':
      # Temporary override of the current version; e.g. v4.0, due to
      # http://issues.collectionspace.org/browse/CSPACE-6294
      # The (v4.1) master branch contains fixes for that issue.
      source_code_revision => 'master',
    }
  }
  
  # OS X
  darwin: {
    # Continuation here from earlier classes in the installation sequence,
    # maintained in the 'site.pp' manifest.
    class { 'cspace_user::user':
    } ->
    # class { 'cspace_postgresql_server': }
    # ->
    class { 'cspace_tarball::globals':
      # Uncomment line below to set release version to a value other than
      # its current default value, '4.0'
      # release_version => "4.0"
    } ->
    class { 'cspace_tarball': }
    ->
    class { 'cspace_source':
      # Temporary override of the current version; e.g. v4.0, due to
      # http://issues.collectionspace.org/browse/CSPACE-6294
      # The (v4.1) master branch contains fixes for that issue.
      source_code_revision => 'master',
    }
  }
  
  # Microsoft Windows
  windows: {
    # Continuation here from earlier classes in the installation sequence,
    # maintained in the 'site.pp' manifest.
    # class { 'cspace_user::user':
    # } ->
    # class { 'cspace_postgresql_server': }
    # ->
    # class { 'cspace_tarball::globals':
    #   # Uncomment line below to set release version; defaults to '4.0'
    #   # release_version => "4.0"
    # } ->
    # class { 'cspace_tarball': }
    # ->
    # class { 'cspace_source': }
  }
  
  default: {
  }
  
}





