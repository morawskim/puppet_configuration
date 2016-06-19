
node default {
  
    include mopensuse::user::marcin
    include mopensuse::packages::apache2
    include mopensuse::services::apache2
    include mopensuse::packages::php
    include mopensuse::packages::vcs
  
    $registerbusiness_path  = '/srv/www/vhosts/itaxi-registerbusiness.dev'
    $registerbusiness_owner = 'marcin'
    $registerbusiness_group = 'www'
    $project_path    = '/home/marcin/projekty/itaxi'
    $project_name    = 'registerbusiness'
    $project_vhost   = "itaxi-$project_name"
  
    file { $registerbusiness_path:
        ensure => directory,
        mode   => '2770',
        owner  => $registerbusiness_owner,
        group  => $registerbusiness_group,
    }

    file { $project_path:
        ensure => directory,
        mode   => '0750',
        owner  => $registerbusiness_owner,
        group  => $registerbusiness_owner
    }

    vcsrepo { $registerbusiness_path:
        ensure   => present,
        provider => git,
        source   => 'git@dev.itaxi.pl:p.kruzynski/registerbusiness.git',
        identity => '/home/marcin/.ssh/work_rsa',
        owner    => $registerbusiness_owner,
        group    => $registerbusiness_group,
        require  => [ File[$registerbusiness_path], Class['mopensuse::packages::vcs'] ]
    }

    host { "$project_vhost.dev":
        ensure       => present,
        ip           => '127.0.0.1',
        host_aliases => ["www.${project_vhost}.dev"]
    }

    file { "${project_path}/${project_name}":
        ensure  => link,
        target  => "$registerbusiness_path",
        require => File[$project_path]
    }

    file { "/etc/apache2/vhosts.d/${project_vhost}.dev.conf":
        ensure  => present,
        mode    => '0744',
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/mprojects/${project_vhost}/${project_vhost}.dev.conf",
        require => [ Class['mopensuse::packages::apache2'], Vcsrepo[$registerbusiness_path] ],
        notify  => Class['mopensuse::services::apache2']
    }

    file { "${registerbusiness_path}/registerbusiness/app/protected/config/main.php":
        ensure  => link,
        target  => "${registerbusiness_path}/registerbusiness/app/protected/config/config-itplock.php",
        require => Vcsrepo[$registerbusiness_path]
    }

    file { "${registerbusiness_path}/registerbusiness/app/protected/runtime":
        ensure  => directory,
        mode    => '2775',
        require => Vcsrepo[$registerbusiness_path]
    }

    file { "${registerbusiness_path}/registerbusiness/assets":
        ensure  => directory,
        mode    => '2775',
        owner   => $registerbusiness_owner,
        group   => $registerbusiness_group,
        require => Vcsrepo[$registerbusiness_path]
    }
}
