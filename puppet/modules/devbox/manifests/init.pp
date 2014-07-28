class devbox {

  /* Setup webserver */

  exec { 'epel-repo':
    command => '/bin/rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'
  }

  exec { 'nginx-repo':
    command => '/bin/rpm -Uvh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm'
  }

  package { 'nginx':
    ensure => 'present',
    require => Exec['nginx-repo']
  }

  file { '/opt/projects/':
    ensure => 'directory',
    owner => 'vagrant',
    mode => 755
  }

  file { 'vagrant-nginx':
    path => '/etc/nginx/conf.d/default.conf',
    ensure => file,
    require => Package['nginx'],
    source => 'puppet:///modules/devbox/centos.dev.conf'
  }

  service { 'nginx':
    ensure => 'running',
    enable => 'true',
    require => File['vagrant-nginx']
  }

  /* Setup MySQL */

  class { '::mysql::server':
    root_password    => 'root',
    override_options => { 'mysqld' => { 'max_connections' => '10' } }
  }

  /* Add packages */

  package {
    ["bash", "yum-utils", "curl", "wget", "screen", "man", "git", "gitflow", "vim-enhanced"]:
      ensure => latest
  }

  /* php 5.5 + fpm + composer etc */

  exec { "webtatic-php55w":
    command => "/bin/rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm",
    require => Package["yum-utils"]
  }

  package {
    ["php55w", "php55w-fpm", "php55w-common", "php55w-soap", "php55w-pdo", "php55w-pecl-memcache", "php55w-pecl-xdebug", "php55w-cli", "php55w-xml"]:
      ensure => latest,
      require => Exec["webtatic-php55w"]
  }

  service { 'php-fpm':
    ensure => running,
    require => Package['php55w-fpm'],
  }

  file { 'php-fpm-conf':
    path => '/etc/php-fpm.d/www.conf',
    ensure => file,
    require => Package['nginx'],
    source => 'puppet:///modules/devbox/www.conf',
    notify => Service['php-fpm']
  }

  exec { 'composer-install':
    command => '/usr/bin/curl -sS https://getcomposer.org/installer | php && /bin/mv composer.phar /usr/local/bin/composer',
    require => Package['php55w']
  }

  firewall { '100 allow http and https access':
    port   => [80, 443],
    proto  => tcp,
    action => accept,
  }
}
