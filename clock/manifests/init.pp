class clock (
    $timezone = "Europe/London",
    $use_utc = true
)
{
  # update the sys clock
  file { '/etc/sysconfig/clock':
    ensure  => present,
    content => template("clock/clock.erb"),
  }
}  
