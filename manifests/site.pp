#
# A puppet site file for a CollectionSpace server
#

# Required for the array 'concat()' function used below.
include stdlib

# ---------------------------------------------------------
# Declare variables
# ---------------------------------------------------------

# CollectionSpace environment variables

# The values below should be reviewed and changed as needed.
# In particular, password values below are set to easily-guessable
# defaults and MUST be changed.
#
# The value of JAVA_HOME is not set here; it is assumed to be present
# in Ant and Maven's environments.

# FIXME: the values below should more flexibly be read in from a
# per-node Environment, from configuration files, or from Heira,
# rather than being hard-coded.
#
# See, for instance:
# http://puppetlabs.com/blog/the-problem-with-separating-data-from-puppet-code
# and specifically:
# http://docs.puppetlabs.com/guides/environment.html
# http://docs.puppetlabs.com/hiera/1/

$cspace_env_vars = [ 
    'ANT_OPTS=-Xmx768m -XX:MaxPermSize=512m',
    'CATALINA_HOME=/usr/local/share/apache-tomcat-6.0.33',
    'CATALINA_OPTS=-Xmx1024m -XX:MaxPermSize=384m',
    'CATALINA_PID=/usr/local/share/apache-tomcat-6.0.33/bin/tomcat.pid',
    'CSPACE_JEESERVER_HOME=/usr/local/share/apache-tomcat-6.0.33',
    'DB_PASSWORD_CSPACE=cspace',
    'DB_PASSWORD_NUXEO=nuxeo',
    'DB_PASSWORD=postgres',
    'LC_ALL=en_US.UTF-8',
    'MAVEN_OPTS=-Xmx768m -XX:MaxPermSize=512m -Dfile.encoding=UTF-8',
]

# Filesystem paths for finding executable files

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
# Identify OS platform
# ---------------------------------------------------------

# When running in standalone mode, identify the operating system (OS) family
# on this host.
#
# The $::osfamily fact was introduced with Facter 1.6.1. If it's not present,
# the following is a workaround used in Puppet Labs' MySQL module; see
# http://jenkner.org/blog/2013/03/27/use-osfamily-instead-of-operatingsystem/

if ! $::osfamily {
  case $::operatingsystem {
    'RedHat', 'Fedora', 'CentOS', 'Scientific', 'SLC', 'Ascendos', 'CloudLinux', 'PSBM', 'OracleLinux', 'OVS', 'OEL': {
      $osfamily = 'RedHat'
    }
    'ubuntu', 'debian': {
      $osfamily = 'Debian'
    }
    'SLES', 'SLED', 'OpenSuSE', 'SuSE': {
      $osfamily = 'Suse'
    }
    'Solaris', 'Nexenta': {
      $osfamily = 'Solaris'
    }
    default: {
      $osfamily = $::operatingsystem
    }
  }
}

# ---------------------------------------------------------
# Instantiate resources for OS platform
# ---------------------------------------------------------

# Instantiate various classes and other resources based on OS family.
#
# (We can add resources to be instantiated to each OS family, as
# they've been tested under at least one instance of that family.)

case $::osfamily {
    # Supported Linux OS families
    RedHat: {
        include cspace_server_dependencies
        include cspace_java
        include cspace_tarball
        class { 'cspace_source':
            env_vars   => $cspace_env_vars,
            exec_paths => $linux_default_exec_paths
        }
    }
    Debian: {
        include cspace_server_dependencies
        include cspace_java
        include cspace_tarball
        class { 'cspace_source':
            env_vars   => $cspace_env_vars,
            exec_paths => $linux_default_exec_paths
        }
    }
    # OS X
    darwin: {
		# include cspace_tarball
        class { 'cspace_source':
            env_vars   => $cspace_env_vars,
            exec_paths => $osx_default_exec_paths
        }
    }
    default: {
    }
}



