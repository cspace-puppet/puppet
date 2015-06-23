puppet
======

A module containing a `site.pp` file to initiate the installation of a
CollectionSpace server instance.

Specifically, an installer shell script, which is in turn installed by
a bootstrap script (see the `cspace-puppet/cspace_puppet_bootstrap` repo),
first invokes `site.pp`, then `post-java.pp`, to perform a standalone
installation of a CollectionSpace server instance via `puppet apply`.

**Please make changes on the appropriate branch for the CollectionSpace
version to be installed**: e.g. `v4.2`, `v4.1`. And create new branches
for new CollectionSpace versions. (The `master` branch is now deprecated.)
