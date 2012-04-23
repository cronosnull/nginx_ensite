# nginx_ensite and nginx_dissite for quick virtual host enabling and disabling

## Description

This is a shell (Bash) script that replicates for
[nginx](http://wiki.nginx.org) the [Debian](http://debian.org)
`a2ensite` and `a2dissite` for enabling and disabling sites as virtual
hosts in Apache 2.2.

The original `a2ensite` and `a2dissite` is written in
Perl. `a2dissite` is a symbolic link to `a2ensite`. Here I followed
the same approach, i.e., `nginx_dissite` is a symbolic link to
`nginx_ensite`.

## Installation 

Just drop the script and the symbolic link in `/usr/sbin` or other
location appropriate for your system. Meaning: `cp nginx_* /usr/sbin`.
That's it you're done. 

Note that the script assumes a specific file system topology for your
`nginx` configuration. Here's the rundown:

 1. All virtual hosts configuration files should be under
    `/etc/nginx/sites-available`. For example the virtual host `foobar`
    is configured through a file in `/etc/sites/available`.

 2. After running the script with `foobar` as argument: `nginx_ensite
    foobar`. A symbolic link `/etc/nginx/sites-enabled/foobar ->
    /etc/nginx/sites-available/foobar` is created. Note that if the
    `/etc/nginx/sites-enabled` directory doesn't exist the script
    creates it.

 2b. If you are running the script without any argument: `nginx_ensite`.
     It will ask you which site to enable.

 3. The script invokes `nginx -t` to test if the configuration is
    correct. If the test fails no symbolic link is created and an error
    is signaled.

 4. If everything is correct now just reload nginx, in Debian based
    systems that means invoking `/etc/init.d/nginx reload`.

 5. Now point the browser to the newly configured host and everything
    should work properly assuming your configuration is sensible.

 6. To disable the site just run `nginx_dissite foobar`. Reload nginx
    to update the running environment.

 6b. If you are running the script without any argument: `nginx_dissite`.
     It will ask you which site to disable.

## Requirements

The script is written in Bash and uses some Bash specific idioms. I
never tested it in other shells. You're welcomed to try it in any other
shell. Please do tell me how it went. 

## Manual pages

Two UNIX manual pages are included in the man directory. They should
be copied to a proper directory in your system. Something along the
lines of `/usr/share/man/man8` or `/usr/local/share/man/man8`.


## Acknowledgments

Thanks to [perusio](http://github.com/perusio) for the original script.
