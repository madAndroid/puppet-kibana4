# == Class: kibana4
#
# Service creation and mgmt
#
class kibana4::service {

  if $kibana4::use_systemd {

    file { "/etc/systemd/system/${kibana4::service_name}.service":
      content => template('kibana4/kibana.systemd.erb'),
      mode    => '0755',
    }
    ~>
    exec { 'execute kibana-service reload':
      command       => '/bin/systemctl daemon-reload',
      refreshonly   => true,
    }

    file { "/etc/init.d/${kibana4::service_name}":
      ensure  => absent,
    }

    $service_require = File["/etc/systemd/system/${kibana4::service_name}.service"]

  } else {

    file { "/etc/init.d/${kibana4::service_name}":
      ensure  => present,
      mode    => '0755',
      content => template('kibana4/kibana.init'),
      group   => root,
      owner   => root,
    }

    $service_require = File["/etc/init.d/${kibana4::service_name}"]

  }

  service { 'kibana4':
    ensure     => $kibana4::service_ensure,
    enable     => $kibana4::service_enable,
    name       => $kibana4::service_name,
    hasstatus  => true,
    hasrestart => true,
    require    => $service_require,
  }

}
