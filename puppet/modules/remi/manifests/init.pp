class remi {

  exec { 'epel-repo':
    command => 'http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'
  }
  exec { 'remi-repo':
    command => 'http://rpms.famillecollet.com/enterprise/remi-release-6.rpm',
    require => Exec['epel-repo']
  }
}