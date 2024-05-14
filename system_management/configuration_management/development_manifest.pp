exec { 'update_package_lists':
  command => '/usr/bin/apt update',
  path => ['/usr/bin', '/usr/sbin', '/bin'],
  unless => '/usr/bin/apt update -qq | /bin/grep "All packages are up to date" >/dev/null',
}

package { 'snapd':
  ensure => installed,
  require => Exec['update_package_lists'],
}

exec { 'install_dvc_snap':
  command => '/usr/bin/snap install dvc --classic',
  path => ['/usr/bin', '/usr/sbin', '/bin'],
  require => Package['snapd'],
}

package { 'python3':
  ensure => installed,
  require => Exec['update_package_lists'],
}

package { 'python3-pip':
  ensure => installed,
  require => Package['python3'],
}

exec { 'install_jupyter_notebook':
  command => '/usr/bin/pip3 install --prefix=/usr/local notebook',
  path => ['/usr/bin', '/usr/sbin', '/bin'],
  require => Package['python3'],
}

file { '/usr/local/bin/full_checkout_script.sh':
  ensure => file,
  mode => '0755',
  owner => 'root',
  group => 'root',
  source => '/tmp/full_checkout_script.sh',
}

file_line { 'add_full_checkout_alias':
  path => '/home/ubuntu/.bashrc',
  line => 'alias full_checkout="/usr/local/bin/full_checkout_script.sh"',
  match => '^alias full_checkout=',
  ensure => present,
}

file { '/usr/local/bin/full_push_script.sh':
  ensure => file,
  mode => '0755',
  owner => 'root',
  group => 'root',
  source => '/tmp/full_push_script.sh',
}

file_line { 'add_full_push_alias':
  path => '/home/ubuntu/.bashrc',
  line => 'alias full_push="/usr/local/bin/full_push_script.sh"',
  match => '^alias full_push=',
  ensure => present,
}
