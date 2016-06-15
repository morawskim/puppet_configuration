
node default {
  
    include mopensuse::user::marcin
    include mopensuse::packages::apache2
    include mopensuse::services::apache2
    include mopensuse::packages::php
    include mopensuse::packages::vcs
  
    $passengerzone_path  = '/srv/www/vhosts/itaxi-client.dev'
    $passengerzone_owner = 'marcin'
    $passengerzone_group = 'www'
    $project_path    = '/home/marcin/projekty/itaxi'
    $project_name    = 'client'
    $project_vhost   = "itaxi-$project_name"
  
    file { $passengerzone_path:
        ensure => directory,
        mode   => '2770',
        owner  => $passengerzone_owner,
        group  => $passengerzone_group,
    }

    file { $project_path:
        ensure => directory,
        mode   => '0750',
        owner  => $passengerzone_owner,
        group  => $passengerzone_owner
    }

    vcsrepo { $passengerzone_path:
        ensure   => present,
        provider => git,
        source   => 'git@dev.itaxi.pl:marcin.morawski/passengerzone.git',
        identity => '/home/marcin/.ssh/work_rsa',
        owner    => $passengerzone_owner,
        group    => $passengerzone_group,
        require  => [ File[$passengerzone_path], Class['mopensuse::packages::vcs'] ]
    }

    host { "$project_vhost.dev":
        ensure       => present,
        ip           => '127.0.0.1',
        host_aliases => ["www.${project_vhost}.dev"]
    }

    file { "${project_path}/${project_name}":
        ensure  => link,
        target  => "$passengerzone_path",
        require => File[$project_path]
    }

    file { "/etc/apache2/vhosts.d/${project_vhost}.dev.conf":
        ensure  => present,
        mode    => '0744',
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/mprojects/${project_vhost}/${project_vhost}.dev.conf",
        require => [ Class['mopensuse::packages::apache2'], Vcsrepo[$passengerzone_path] ],
        notify  => Class['mopensuse::services::apache2']
    }

    file { "${passengerzone_path}/strefaklienta/protected/runtime":
        ensure  => directory,
        mode    => '2775',
        require => Vcsrepo[$passengerzone_path]
    }

    file { "${passengerzone_path}/strefaklienta/assets":
        ensure  => directory,
        mode    => '2775',
        owner   => $passengerzone_owner,
        group   => $passengerzone_group,
        require => Vcsrepo[$passengerzone_path]
    }
}
