user { 'dvc-user':
  ensure => present,
  managehome => true,
  shell => '/bin/bash'
}

file { '/home/dvc-user/.ssh':
  ensure => directory,
  owner => 'dvc-user',
  group => 'dvc-user',
  mode => '0700',
  require => User['dvc-user'],
}

file { '/home/dvc-user/.ssh/authorized_keys':
  ensure => file,
  owner => 'dvc-user',
  group => 'dvc-user',
  mode => '0600',
  require => File['/home/dvc-user/.ssh'],
}

file_line { 'dvc_user_ssh_key':
  path => '/home/dvc-user/.ssh/authorized_keys',
  line => 'ssh-rsa AAAA... ubuntu@master-server', # fill with the master server public ssh key
  match => '^ssh-rsa.*\s+ubuntu@master-server$',
  require => File['/home/dvc-user/.ssh/authorized_keys'],
}
