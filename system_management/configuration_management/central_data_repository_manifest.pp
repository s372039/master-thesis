package { 'docker.io':
  ensure => installed
}

service { 'docker':
  ensure => running,
  enable => true,
  require => Package['docker.io']
}

exec { 'install docker-compose':
  command => 'curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose',
  path => ['/bin', '/usr/bin'],
  unless => 'test -f /usr/local/bin/docker-compose',
}

package { 'gitlab-runner':
  ensure => installed,
  provider => 'apt',
}

service { 'gitlab-runner':
  ensure    => running,
  enable    => true,
  require   => Package['gitlab-runner'],
}
