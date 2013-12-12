# Sample Usage:
#
#   postgresql_backup { 'my application':
#     db_host     => 'postgres.example.com',
#     db_pass     => 'db pass',
#     db_user     => 'postgres',
#     db_name     => 'postgres',
#     backup_path => '/backups',
#   }
#
<<<<<<< HEAD

class postgresql_backup {
  concat { $pgpass:
    owner => $owner,
    group => $group,
    mode  => '0600'
  }

  concat::fragment { 'postgresql_backup header':
    target  => $pgpass,
    content => "\nPuppet managed postgresql_backups. Changes made to this file will not be saved\n\n",
    order   => '01'
  }
}

=======
>>>>>>> parent of 1b12ad8... Removing init.pp. Trying to put the concat stuff outside of the define type so you don't get errors when using it more than once
define postgresql_backup::db (
  $db_host     = undef,
  $db_pass     = undef,
  $db_user     = undef,
  $db_name     = undef,
  $backup_path = undef,
  $group       = 'root',
  $owner       = 'root',
  $ensure      = present,
  $pgpass      = '/root/.pgpass'
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

# concat { $pgpass:
#   owner => $owner,
#   group => $group,
#   mode  => '0600'
# }

  concat::fragment { $title:
    target  => $pgpass,
    content => "${db_host}:5432:${db_name}:${db_user}:${db_pass}\n",
    order   => '1'
  }
}