#!/bin/sh -e

USAGE="$0 [ --update ]"
export ORACLE_VERSION=19.3.0.0.0

echo "Building and Loading Policy"
set -x
make -f /usr/share/selinux/devel/Makefile oracle.pp || exit
/usr/sbin/semodule -i oracle.pp

# Generate a man page off the installed module
sepolicy manpage -p . -d oracle_t

# Fixing file contexts
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin

# Generate a rpm package for the newly generated policy

pwd=$(pwd)
rpmbuild --define "_sourcedir ${pwd}" --define "_specdir ${pwd}" --define "_builddir ${pwd}" --define "_srcrpmdir ${pwd}" --define "_rpmdir ${pwd}" --define "_buildrootdir ${pwd}/.build"  -ba oracle_selinux.spec
