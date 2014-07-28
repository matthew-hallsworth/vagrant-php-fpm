## vagrant-php-fpm

A setup of Vagrant with nginx and php-fpm for development purposes. Built on a mac for use with Virtualbox.

Install with the basebox in the Vagrantfile.dist in the basebox folder, or, use your own!

Equivalent basebox will contain:

- Centos 6.4 x86_64
- VirtualBox Guest Additions 4.3.2
- Puppet 3.3.1

Tested on OSX Mavericks with:

- Virtualbox 4.3.12
- Vagrant for OSX 1.5.4

### Quirks

- The default install looks at /opt/projects/www - if you wish to install Symfony etc., you can share the folder in and just symlink /opt/projects/www into your web folder in the chosen project.
- The default nginx config is not optimised for Symfony use, it is a generic config. You should customise the nginx config for whatever framework or codebase you are choosing to use.
- The default hosts file entry required is `10.0.0.20 centos.dev` however this can be changed to anything - localhost:8080 also works.
