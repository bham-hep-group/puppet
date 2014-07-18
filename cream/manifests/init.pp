class cream
(
  $pbs_host,
  $gridmap_nfs_restriction,
  $firewall_src = ''
)
{
  
  # ----------------------------------------
  # Usual package structure
  package { "emi-cream-ce":
    ensure => installed,
    require => Class["emirepo"],
  }

  # ----------------------------------------
  # install approrpriate torque components
  package { "emi-torque-utils":
    ensure => installed,
    require => Package["emi-cream-ce"],
  }

  package { "xml-commons-apis":
    ensure => installed,
    require => Package["emi-torque-utils"],
  }
  
  
  service { "munge":
    name   => 'munge',
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => File["/etc/munge/munge.key"],
  }
  
  # -----------------------------------------------
  # mounts required
  file { "torque-root":
    path => "/var/lib/torque",
    ensure => directory,
    owner => "root",
    group => "root",
  }

  file { "server-logs":
    path => "/var/lib/torque/server_logs",
    ensure => directory,
    owner => "root",
    group => "root",
  }
  
  file { "server-priv":
    path => "/var/lib/torque/server_priv",
    ensure => directory,
    owner => "root",
    group => "root",
  }
  
  file { "server-priv-acct":
    path => "/var/lib/torque/server_priv/accounting",
    ensure => directory,
    owner => "root",
    group => "root",
    mode => 0644,
    require => File["server-priv"]
  }
  
  mount { "/var/lib/torque/server_priv/accounting":
    device => "${pbs_host}:/var/lib/torque/server_priv/accounting",
    fstype => "nfs",
    ensure => "mounted",
    options => "ro",
    atboot => true,
    require => File["server-priv-acct"],
  }

  mount { "/var/lib/torque/server_logs":
    device => "${pbs_host}:/var/log/torque/server_logs",
    fstype => "nfs",
    ensure => "mounted",
    options => "ro",
    atboot => true,
    require => File["server-logs"],
  }

  # export the gridmapdir
  nfs::export { 'cream_gridmapdir' :
    path => '/etc/grid-security/gridmapdir/',
    allow_hosts => $gridmap_nfs_restriction,
    options => "rw,sync,no_root_squash"
  }

  # ----------------------------------------
  # add holes for iptables
  firewall {"890 bdii-tcp":
    action => "accept",
    dport => '2170',
    proto => 'tcp',
    source => $firewall_src,
  }
  
  firewall {"891 cream-port-8443":
    action => "accept",
    dport => '8443',
    proto => 'tcp',
  }
  
  firewall {"892 cream-port-8005":
    action => "accept",
    dport => '8005',
    proto => 'tcp',
  }
  
  firewall {"893 cream-port-8009":
    action => "accept",
    dport => '8009',
    proto => 'tcp',
  }
  
  firewall {"894 cream-port-9091":
    action => "accept",
    dport => '9091',
    proto => 'tcp',
    source => $firewall_src,
  }

  firewall {"895 cream-port-9909":
    action => "accept",
    dport => '9909',
    proto => 'tcp',
    source => $firewall_src,
  }
  
  firewall {"896 cream-port-33332":
    action => "accept",
    dport => '33332',
    proto => 'tcp',
  }

  firewall {"897 cream-port-56565":
    action => "accept",
    dport => '56565',
    proto => 'tcp',
  }
  
  firewall {"898 cream-port-33333":
    action => "accept",
    dport => '33333',
    proto => 'tcp',
  }
  
  firewall {"899 cream-port-56566":
    action => "accept",
    dport => '56566',
    proto => 'tcp',
  }
  
  firewall {"900 cream-port-9000":
    action => "accept",
    dport => '9000',
    proto => 'tcp',
  }
  
  firewall {"901 cream-port-9002":
    action => "accept",
    dport => '9002',
    proto => 'tcp',
    source => $firewall_src,
  }
  
  firewall {"902 mysql-port-3306":
    action => "accept",
    dport => '3306',
    proto => 'tcp',
    source => $firewall_src,
  }

  firewall {"903 gridftp-main":
    action => "accept",
    dport => '2811',
    proto => 'tcp',
  }

  firewall {"904 gridftp-highports":
    action => "accept",
    dport => '20000-25000',
    proto => 'tcp',
  }

  firewall {"905 argus":
    action => "accept",
    dport => '8154',
    proto => 'tcp',
    source => $firewall_src,
  }

  firewall {"906 scp from subnet":
    action => "accept",
    dport => '22',
    proto => 'tcp',
    source => $firewall_src,
  }
}
                                                                                                                                                            
