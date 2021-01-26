# vim: sw=4:ts=4:et

%define oracle_base /oraapp/oracle
%define oracle_data /oraapp/oraInventory
%define selinux_policyver 3.13.1-268

%global selinuxtype targeted
%global moduletype contrib
%global modulename oracle

Name:   oracle-selinux
Version:	1.0.0
Release:	0%{?dist}.spe
Summary:	SELinux policy module for oracle databases at Sony Pictures

Group:	System Environment/Base		
License:	Proprietary
Source:		%{name}-%{version}.tar.gz

Requires: policycoreutils, libselinux-utils
Requires(post): selinux-policy-base >= %{selinux_policyver}, policycoreutils
Requires(postun): policycoreutils
BuildRequires: selinux-policy-devel, policycoreutils-devel
BuildArch: noarch

%{?el7:Requires(pre): policycoreutils-python}
%{?el7:Requires(preun): policycoreutils-python}

%{?el8:Requires(pre): policycoreutils-python-utils}
%{?el8:Requires(preun): policycoreutils-python-utils}

%description
This package installs and sets up the  SELinux policy security module for oracle.

%prep
%setup -q 

%build
%{__make} -f /usr/share/selinux/devel/Makefile oracle.pp
%{__bzip2} -9 oracle.pp
/usr/sbin/semodule -X 999 -i oracle.pp.bz2
/usr/bin/sepolicy manpage -p . -d oracle_t oracle_lsnr_t
/usr/sbin/semodule -X 999 -r oracle

%install
install -d %{buildroot}%{_datadir}/selinux/packages
install -m 644 oracle.pp.bz2 %{buildroot}%{_datadir}/selinux/packages
install -d %{buildroot}%{_datadir}/selinux/devel/include/contrib
install -m 644 oracle.if %{buildroot}%{_datadir}/selinux/devel/include/contrib
install -d %{buildroot}%{_mandir}/man8/
install -m 644 oracle_selinux.8 %{buildroot}%{_mandir}/man8/oracle_selinux.8
install -m 644 oracle_lsnr_selinux.8 %{buildroot}%{_mandir}/man8/oracle_lsnr_selinux.8
install -d %{buildroot}/etc/selinux/targeted/contexts/users/
install -m 644 oracle_u %{buildroot}/etc/selinux/targeted/contexts/users/oracle_u

%clean

%pre
%selinux_relabel_pre -s %{selinuxtype}

%posttrans
%selinux_relabel_post -s %{selinuxtype} || :

%post
%selinux_modules_install -s %{selinuxtype} %{_datadir}/selinux/packages/%{modulename}.pp.bz2 || :
/usr/sbin/semanage user -a -r s0-s0:c0.c1023 -R 'staff_r oracle_r oracle_lsnr_r' oracle_u || :

while read -r user ; do
    if [ -n $user ]; then
        /usr/sbin/semanage login -a -s oracle_u $user || :
    fi;
done <<<"`getent passwd | grep -E 'cyb-uprv-[pdq]dba' | cut -f1 -d:`"

for group in oracle; do
    getent group $group > /dev/null;

    if [ $? -eq 0 ]; then
        /usr/sbin/semanage login -a -s oracle_u %%${group} || :
    fi;
done

%preun

while read -r user ; do
    if [ -n $user ]; then
        /usr/sbin/semanage login -d $user || :
    fi;
done <<<"`getent passwd | grep -E 'cyb-uprv-[pdq]dba' | cut -f1 -d:`"

for group in oracle; do
    getent group $group > /dev/null;

    if [ $? -eq 0 ]; then
        /usr/sbin/semanage login -d %%${group} || :
    fi;
done

/usr/sbin/semanage user -d oracle_u || :


%postun
if [ $1 -eq 0 ]; then
    %selinux_modules_uninstall -s %{selinuxtype} %{modulename} || :
fi

%files
%attr(0600,root,root) %{_datadir}/selinux/packages/oracle.pp.bz2
%{_datadir}/selinux/devel/include/%{moduletype}/oracle.if
%{_mandir}/man8/oracle_selinux.8.*
%{_mandir}/man8/oracle_lsnr_selinux.8.*
/etc/selinux/targeted/contexts/users/oracle_u


%changelog
* Mon Jan 25 2021 Alan Willis <Alan_Willis@spe.sony.com> 1.0.0-0spe
- Pre-release version for internal testing
