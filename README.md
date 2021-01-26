# oracle-selinux
SELinux policy module for Oracle

## Features

This policy has been tested with Oracle Enterprise 19c on CentOS 8

Supported:

- The dbca configuration tool works with X11 over ssh
- Listener and database processes are separated into their own SELinux domains

## Troubleshooting

This policy may be used in permissive mode, which can be enabled by `setenforce permissive`. 

Use `semodule -DB` to rebuild the system policy without "dontaudit"
rules. This will reveal access denial messages that are normally hidden.

After taking both of these steps, `cat <audit log> | audit2allow -R` 
will reveal any additional rules that should be considered for inclusion in this policy.