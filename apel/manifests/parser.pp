class apel::parser
(
  $mysql_pw,
  $site_name,
  $apel_host,
  $torque_host
)
{
  package { "apel-parsers":
    ensure => installed,
    require => Class["emirepo"],
  }
  
  file { '/etc/apel/parser.cfg':
    ensure  => present,
    content => template("apel/parser.cfg.erb"),
    require => Package['apel-parsers'],
    mode => 0600,
  }

  cron { "apel-parser":
    command => "/usr/bin/apelparser",
    user    => root,
    hour  => '4',
    minute => '0',
    require => Package['apel-parsers']
  }
}
