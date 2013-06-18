class db::mysql (
  $root_password,
  $databases = {},  
  $port = 3306
) {
  class { '::mysql': }
  class { 'mysql::server':
    config_hash => { 'root_password' => $root_password, 'bind_address' => '0.0.0.0', 'port' => $port }
  }

  create_resources('mysql::db', $databases)
  mysql::db { $db_name:
    user     => $db_user,
    password => $db_password,
  }

  firewall { '100 allow MySQL database access':
    port   => [$port],
    proto  => tcp,
    action => accept,
  }
}
