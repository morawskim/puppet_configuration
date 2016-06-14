
node default {
  
    include mopensuse::user::marcin
    include mopensuse::packages::apache2
    include mopensuse::services::apache2
    include mopensuse::packages::php
    include mopensuse::packages::vcs
  
    $adminlite_path  = '/srv/www/vhosts/itaxi-adminlite.dev'
    $adminlite_owner = 'marcin'
    $adminlite_group = 'www'
    $project_path    = '/home/marcin/projekty/itaxi'
    $project_name    = 'adminlite'
    $project_vhost   = "itaxi-$project_name"
  
    file { $adminlite_path:
        ensure => directory,
        mode   => '2770',
        owner  => $adminlite_owner,
        group  => $adminlite_group,
    }

    file { $project_path:
        ensure => directory,
        mode   => '0750',
        owner  => $adminlite_owner,
        group  => $adminlite_owner
    }

    vcsrepo { $adminlite_path:
        ensure   => present,
        provider => git,
        source   => 'git@dev.itaxi.pl:tomek/itaxiadminlite.git',
        identity => '/home/marcin/.ssh/work_rsa',
        owner    => $adminlite_owner,
        group    => $adminlite_group,
        require  => [ File[$adminlite_path], Class['mopensuse::packages::vcs'] ]
    }

    host { "$project_vhost.dev":
        ensure       => present,
        ip           => '127.0.0.1',
        host_aliases => ["www.${project_vhost}.dev"]
    }

    file { "${project_path}/${project_name}":
        ensure  => link,
        target  => "$adminlite_path",
        require => File[$project_path]
    }

    file { "/etc/apache2/vhosts.d/${project_vhost}.dev.conf":
        ensure  => present,
        mode    => '0744',
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/mprojects/${project_vhost}/${project_vhost}.dev.conf",
        require => [ Class['mopensuse::packages::apache2'], Vcsrepo[$adminlite_path] ],
        notify  => Class['mopensuse::services::apache2']
    }

    file { "${adminlite_path}/admin/protected/app/config/local-config.php":
        ensure  => link,
        target  => "${adminlite_path}/admin/protected/app/config/config-itplock.php",
        require => Vcsrepo[$adminlite_path]
    }

    file { "${adminlite_path}/admin/protected/app/runtime":
        ensure  => directory,
        mode    => '2775',
        require => Vcsrepo[$adminlite_path]
    }

    file { "${adminlite_path}/admin/assets":
        ensure  => directory,
        mode    => '2775',
        owner   => $adminlite_owner,
        group   => $adminlite_group,
        require => Vcsrepo[$adminlite_path]
    }
}
