#
# A puppet site file for a CollectionSpace server
#

include cspace_environment::env
include cspace_environment::osfamily
include cspace_environment::tempdir
# Required for the array 'concat()' function used below.
include stdlib

# ---------------------------------------------------------
# Declare paths for finding executable files
# ---------------------------------------------------------

# FIXME: Use existing PATH values from the environment, if available

$linux_default_exec_paths = [
    '/bin',
    '/usr/bin',
]

# Default executables path for the third-party Homebrew
# package manager for OS X
$osx_homebrew_exec_paths = [
    '/usr/local/bin',
]
$osx_default_exec_paths = concat( $osx_homebrew_exec_paths, $linux_default_exec_paths )


# ---------------------------------------------------------
# Globally set Exec path (optional)
# ---------------------------------------------------------

# Uncomment if desired to globally set a default Exec path.
#
# This can help prevent errors of the type:
# '{command} is not qualified and no path was specified.
# Please qualify the command or specify a path.'
# where a full path to a command was not specified for
# an Exec resource, and no 'path' parameter was included.
# See http://www.puppetcookbook.com/posts/set-global-exec-path.html

# Exec {
#   # path => $linux_default_exec_paths
#   # path => $osx_default_exec_paths
# }

# ---------------------------------------------------------
# Instantiate resources for OS platform
# ---------------------------------------------------------

# Instantiate various classes and other resources based on OS family.
#
# (We can add resources to be instantiated to each OS family, as
# they've been tested under at least one instance of that family.)

$os_family = $cspace_environment::osfamily::os_family
$cspace_env_vars = $cspace_environment::env::cspace_env_vars

case $os_family {
    # Supported Linux OS families
    RedHat: {
        class { 'cspace_server_dependencies': }
		->
        class { 'cspace_java': }
		->
        class { 'cspace_tarball': }
		->
        class { 'cspace_source':
            env_vars   => $cspace_env_vars,
            exec_paths => $linux_default_exec_paths
        }
    }
    Debian: {
        class { 'cspace_server_dependencies': }
		->
        class { 'cspace_java': }
		->
        class { 'cspace_tarball': }
		->
        class { 'cspace_source':
            env_vars   => $cspace_env_vars,
            exec_paths => $linux_default_exec_paths
        }
    }
    # OS X
    darwin: {
		# class { 'cspace_tarball': }
		# ->
        class { 'cspace_source':
            env_vars   => $cspace_env_vars,
            exec_paths => $osx_default_exec_paths
        }
    }
    default: {
    }
}





