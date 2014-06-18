class backup (
  $backup_master
)
{
  file { "/backup" :
    ensure => directory,
  }
              
  mount { "/backup":
    device => "${backup_master}:/backup_master/machines",
    fstype => "nfs",
    ensure => "mounted",
    options => "defaults",
    atboot => true,
    require => File["/backup"]
  }

  file { "/backup/${hostname}" :
    ensure => directory,
    require => Mount["/backup"]
  }
  
}
