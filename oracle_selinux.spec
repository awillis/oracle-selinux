# vim: sw=4:ts=4:et

%define oracle_base /oraapp/oracle
%define oracle_data /oraapp/oraInventory
%define oracle_version 19.3.0.0.0

%define relabel_files() \
restorecon -F -R -v %{oracle_base}/product/%{oracle_version}/bin \
# restorecon -F -R -v %{oracle_base}/admin \
# restorecon -F -R -v %{oracle_base}/audit \
# restorecon -F -R -v %{oracle_base}/cfgtoollogs \
# restorecon -F -R -v %{oracle_base}/checkpoints \
# restorecon -F -R -v %{oracle_base}/diag \
# restorecon -F -R -v %{oracle_base}/fast_recovery_area \
# restorecon -F -R -v %{oracle_base}/oradata \
# restorecon -F -R -v %{oracle_base}/recovery_area \
# restorecon -F -R -v %{oracle_data}

%define selinux_policyver 3.14.3-54

Name:   oracle_selinux
Version:	1.0_%{oracle_version}
Release:	1%{?dist}
Summary:	SELinux policy module for oracle

Group:	System Environment/Base		
License:	Proprietary
Source0:	oracle.pp
Source1:	oracle.if
Source2:	oracle_selinux.8


Requires: policycoreutils, libselinux-utils
Requires(post): selinux-policy-base >= %{selinux_policyver}, policycoreutils
Requires(postun): policycoreutils
BuildArch: noarch

%description
This package installs and sets up the  SELinux policy security module for oracle.

%install
install -d %{buildroot}%{_datadir}/selinux/packages
install -m 644 %{SOURCE0} %{buildroot}%{_datadir}/selinux/packages
install -d %{buildroot}%{_datadir}/selinux/devel/include/contrib
install -m 644 %{SOURCE1} %{buildroot}%{_datadir}/selinux/devel/include/contrib
install -d %{buildroot}%{_mandir}/man8/
install -m 644 %{SOURCE2} %{buildroot}%{_mandir}/man8/oracle_selinux.8
install -d %{buildroot}/etc/selinux/targeted/contexts/users/


%post
semodule -n -i %{_datadir}/selinux/packages/oracle.pp
if /usr/sbin/selinuxenabled ; then
    /usr/sbin/load_policy
    %relabel_files

fi;
exit 0

%postun
if [ $1 -eq 0 ]; then
    semodule -n -r oracle
    if /usr/sbin/selinuxenabled ; then
       /usr/sbin/load_policy
       %relabel_files

    fi;
fi;
exit 0

%files
%attr(0600,root,root) %{_datadir}/selinux/packages/oracle.pp
%{_datadir}/selinux/devel/include/contrib/oracle.if
%{_mandir}/man8/oracle_selinux.8.*


%changelog
* Thu Jan  7 2021 Alan Willis <Alan_Willis@spe.sony.com> %{version}-%{release}
- Initial version

