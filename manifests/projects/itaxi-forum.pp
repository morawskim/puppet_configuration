
node default {
  
    include mopensuse::user::marcin
    include mopensuse::packages::apache2
    include mopensuse::services::apache2
    include mopensuse::packages::php
    include mopensuse::packages::vcs
  
    $forum_path  = '/srv/www/vhosts/itaxi-forum.dev'
    $forum_owner = 'marcin'
    $forum_group = 'www'
    $project_path    = '/home/marcin/projekty/itaxi'
    $project_name    = 'forum'
    $project_vhost   = "itaxi-$project_name"
  
    file { $forum_path:
        ensure => directory,
        mode   => '2770',
        owner  => $forum_owner,
        group  => $forum_group,
    }

    file { $project_path:
        ensure => directory,
        mode   => '0750',
        owner  => $forum_owner,
        group  => $forum_owner
    }

    vcsrepo { $forum_path:
        ensure   => present,
        provider => git,
        source   => 'git@dev.itaxi.pl:t.zalewski/driversforum.git',
        identity => '/home/marcin/.ssh/work_rsa',
        owner    => $forum_owner,
        group    => $forum_group,
        require  => [ File[$forum_path], Class['mopensuse::packages::vcs'] ]
    }

    host { "$project_vhost.dev":
        ensure       => present,
        ip           => '127.0.0.1',
        host_aliases => ["www.${project_vhost}.dev"]
    }

    file { "${project_path}/${project_name}":
        ensure  => link,
        target  => "$forum_path",
        require => File[$project_path]
    }

    file { "/etc/apache2/vhosts.d/${project_vhost}.dev.conf":
        ensure  => present,
        mode    => '0744',
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/mprojects/${project_vhost}/${project_vhost}.dev.conf",
        require => [ Class['mopensuse::packages::apache2'], Vcsrepo[$forum_path] ],
        notify  => Class['mopensuse::services::apache2']
    }

    file { "${forum_path}/forum/config.php":
        ensure  => link,
        target  => "${forum_path}/forum/config-itplock.php",
        require => Vcsrepo[$forum_path]
    }
}
