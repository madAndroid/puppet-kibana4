# == Class: kibana4
#
# Configuration
#
class kibana4::config {

  $version = $kibana4::package_ensure

  if $kibana4::use_official_repos {
    $config_file = '/opt/kibana/config/kibana.yml'
  } else {
    $config_file = "${kibana4::install_dir}/kibana-${version}/config/kibana.yml"
  }

  file { $config_file:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('kibana4/kibana.yml.erb'),
    notify  => Service['kibana4'],
  }

  file { $kibana4::log_path:
    ensure  => directory,
    owner   => $kibana4::kibana4_user,
    group   => $kibana4::kibana4_group,
  }
  ->
  file { '/etc/logrotate.d/kibana':
    content => template('kibana4/kibana4.logrotate.erb'),
  }

}
