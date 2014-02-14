class db::mysql (
  $root_password,
  $databases = {},  
  $port = 3306,
  $backup = false,
  $backup_user = 'backup',
  $backup_password = 'secretpassword',
  $backup_dir = '/var/backup',
) {
  if !defined(Class['::mysql::server']) {
    class { '::mysql::server':
      root_password => $root_password, 
      override_options => { 
        mysqld => {
          'bind_address' => '0.0.0.0', 'port' => $port 
        }
      }
    }
  }

  create_resources('mysql::db', $databases)

  if $backup {
    class {'mysql::server::backup':
      backupuser => $backup_user,
      backuppassword => $backup_password,
      backupdir => $backup_dir,
      backupdatabases => keys($databases),
    }
  }

  firewall { '100 allow MySQL database access':
    port   => [$port],
    proto  => tcp,
    action => accept,
  }
}
