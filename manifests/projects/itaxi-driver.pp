
node default {
  
    include mopensuse::user::marcin
    include mopensuse::packages::apache2
    include mopensuse::services::apache2
    include mopensuse::packages::php
    include mopensuse::packages::vcs
  
    $driver_path  = '/srv/www/vhosts/itaxi-driver.dev'
    $driver_owner = 'marcin'
    $driver_group = 'www'
    $project_path    = '/home/marcin/projekty/itaxi'
    $project_name    = 'driver'
    $project_vhost   = "itaxi-$project_name"
  
    file { $driver_path:
        ensure => directory,
        mode   => '2770',
        owner  => $driver_owner,
        group  => $driver_group,
    }

    file { $project_path:
        ensure => directory,
        mode   => '0750',
        owner  => $driver_owner,
        group  => $driver_owner
    }

    vcsrepo { $driver_path:
        ensure   => present,
        provider => git,
        source   => 'git@dev.itaxi.pl:p.kowalski/newdriverregisterform.git',
        identity => '/home/marcin/.ssh/work_rsa',
        owner    => $driver_owner,
        group    => $driver_group,
        require  => [ File[$driver_path], Class['mopensuse::packages::vcs'] ]
    }

    host { "$project_vhost.dev":
        ensure       => present,
        ip           => '127.0.0.1',
        host_aliases => ["www.${project_vhost}.dev"]
    }

    file { "${project_path}/${project_name}":
        ensure  => link,
        target  => "$driver_path",
        require => File[$project_path]
    }

    file { "/etc/apache2/vhosts.d/${project_vhost}.dev.conf":
        ensure  => present,
        mode    => '0744',
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/mprojects/${project_vhost}/${project_vhost}.dev.conf",
        require => [ Class['mopensuse::packages::apache2'], Vcsrepo[$driver_path] ],
        notify  => Class['mopensuse::services::apache2']
    }

    file { "${driver_path}/protected/runtime":
        ensure  => directory,
        mode    => '2775',
        require => Vcsrepo[$driver_path]
    }

    file { "${driver_path}/assets":
        ensure  => directory,
        mode    => '2775',
        owner   => $driver_owner,
        group   => $driver_group,
        require => Vcsrepo[$driver_path]
    }
}
