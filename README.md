# ngx-*site script suite

## Description

This is a collection of shell (Bash) script to manage nginx virtual hosts
The createServerProxy script creates a new proxy "server block" (virtual host) in sites-available folder.

## Installation 

Just drop the script and the symbolic links in `/usr/sbin` or other
location appropriate for your system. Meaning: `cp ngx-*site /usr/sbin`.

## Requirements

The script is written in Bash.

## Acknowledgments

Thanks to [perusio](http://github.com/perusio) for the original script.
