#!/bin/sh -e

DIRNAME=`dirname $0`
cd $DIRNAME
USAGE="$0 [ --update ]"
export ORACLE_VERSION=193000

if [ `id -u` != 0 ]; then
echo 'You must be root to run this script'
exit 1
fi

if [ $# -eq 1 ]; then
	if [ "$1" = "--update" ] ; then
		time=`ls -l --time-style="+%x %X" oracle.te | awk '{ printf "%s %s", $6, $7 }'`
		rules=`ausearch --start $time -m avc --raw -se oracle`
		if [ x"$rules" != "x" ] ; then
			echo "Found avc's to update policy with"
			echo -e "$rules" | audit2allow -R
			echo "Do you want these changes added to policy [y/n]?"
			read ANS
			if [ "$ANS" = "y" -o "$ANS" = "Y" ] ; then
				echo "Updating policy"
				echo -e "$rules" | audit2allow -R >> oracle.te
				# Fall though and rebuild policy
			else
				exit 0
			fi
		else
			echo "No new avcs found"
			exit 0
		fi
	else
		echo -e $USAGE
		exit 1
	fi
elif [ $# -ge 2 ] ; then
	echo -e $USAGE
	exit 1
fi

echo "Building and Loading Policy"
set -x
make -f /usr/share/selinux/devel/Makefile oracle.pp || exit
/usr/sbin/semodule -i oracle.pp

# Generate a man page off the installed module
sepolicy manpage -p . -d oracle_t

# Fixing file contexts
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/adrci
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/afdboot
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/agtctl
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/amdu
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/ctxkbtc
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/ctxlc
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/ctxload
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/cursize
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/dbfs_client
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/dbfsize
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/dbnest
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/dbnestinit
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/dbv
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/dg4odbc
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/dg4pwd
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/dgmgrl
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/drdactl
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/drdalsnr
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/drdaproc
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/dsml2ldif
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/dumpsga
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/exp
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/expdp
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/extjob
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/extjobo
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/extproc
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/fmputl
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/fmputlhp
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/genezi
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/genksms
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/hsalloci
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/hsdepxa
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/hsots
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/imp
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/impdp
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/jssu
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/kfed
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/kgmgr
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/lcsscan
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/ldapadd
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/ldapaddmt
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/ldapbind
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/ldapcompare
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/ldapdelete
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/ldapmoddn
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/ldapmodify
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/ldapmodifymt
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/ldapsearch
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/lmsgen
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/loadpsp
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/lsnodes
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/lsnrctl
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/lxchknlb
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/lxegen
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/lxinst
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/mapsga
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/maxmem
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/mkpatch
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/nid
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/okdstry
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/okinit
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/oklist
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/olfsctl
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/oputil
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/orabase
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/orabaseconfig
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/orabasehome
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/oracle
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/oradism
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/oradnfs
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/oraping
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/orapwd
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/oraversion
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/orion
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/osdbagrp
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/osh
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/plshprof
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/proc
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/procob
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/rawutl
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/renamedg
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/rman
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/rtsora
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/sbttest
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/schema
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/setasmgid
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/skgxpinfo
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/sqlldr
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/sqlplus
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/sysresv
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/tkprof
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/tnslsnr
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/tnsping
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/trcldr
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/trcroute
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/tstshm
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/uidrvci
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/wrap
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/wrc
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/xml
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/xmlcg
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/xmldiff
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/xmlpatch
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/xmlwf
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/xsl
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/xvm
/sbin/restorecon -F -R -v /oraapp/oracle/product/${ORACLE_VERSION}/bin/zip

# Generate a rpm package for the newly generated policy

pwd=$(pwd)
rpmbuild --define "_sourcedir ${pwd}" --define "_specdir ${pwd}" --define "_builddir ${pwd}" --define "_srcrpmdir ${pwd}" --define "_rpmdir ${pwd}" --define "_buildrootdir ${pwd}/.build"  -ba oracle_selinux.spec
