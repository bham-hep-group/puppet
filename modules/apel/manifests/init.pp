class apel
(
  $mysql_pw,
  $site_name
)
{
    package { "apel-client":
      ensure => installed,
      require => Class["emirepo"],
    }
    
    package { "lcg-CA":
      ensure => installed,
    }

    file { '/etc/apel/client.cfg':
      ensure  => present,
      content => template("apel/client.cfg.erb"),
      require => Package['apel-client'],
      mode => 0600,
    }

    file { '/etc/apel/sender.cfg':
      ensure  => present,
      content => template("apel/sender.cfg.erb"),
      require => Package['apel-client'],
      mode => 0600,
    }

    cron { "apel-client":
      command => "/usr/bin/apelclient",
      user    => root,
      hour  => '4',
      minute => '0',
      require => Package['apel-client']
    }
          
}
