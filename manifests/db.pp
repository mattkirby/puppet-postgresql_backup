# Sample Usage:
#
#   postgresql_backup { 'my application':
#     db_host     => 'postgres.example.com',
#     db_pass     => 'db pass',
#     db_user     => 'postgres',
#     db_title     => 'postgres',
#     backup_path => '/backups',
#   }
#
define postgresql_backup::db (
  $db_host,
  $db_pass,
  $db_user,
  $db_title,
  $backup_path,
  $group  = 'root',
  $owner  = 'root',
  $ensure = present,
  $pgpass = '/root/.pgpass',
) {
  file { "/usr/local/bin/${title}_backup":
    ensure => $ensure,
    group  => $group,
    owner  => $owner,
    mode   => '0755',
    source => template('postgresql_backup/postgresql_backup.erb')
  }

  file { "/etc/${title}_backup.conf":
    ensure  => $ensure,
    group   => $group,
    owner   => $owner,
    mode    => '0600',
    content => template('postgresql_backup/postgresql_backup.conf.erb')
  }

  concat { $pgpass:
    owner => $owner,
    group => $group,
    mode  => '0600'
  }

  concat::fragment { $title:
    target  => $pgpass,
    content => "\n${db_host}:5432:${db_name}:${db_user}:${db_pass}\n",
    order   => '1'
  }
}
