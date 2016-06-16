
node default {
  
    include mopensuse::user::marcin
    include mopensuse::packages::php
    include mopensuse::packages::vcs
  
    $project_path    = '/home/marcin/projekty/itaxi'
    $chargeclient_owner = 'marcin'
    $chargeclient_group = 'marcin'
    $chargeclient_path  = "${project_path}/charge-client"
  
    file { $chargeclient_path:
        ensure => directory,
        mode   => '2770',
        owner  => $chargeclient_owner,
        group  => $chargeclient_group,
    }

    file { $project_path:
        ensure => directory,
        mode   => '0750',
        owner  => $chargeclient_owner,
        group  => $chargeclient_owner
    }

    vcsrepo { $chargeclient_path:
        ensure   => present,
        provider => git,
        source   => 'git@dev.itaxi.pl:p.kruzynski/chargeclient.git',
        identity => '/home/marcin/.ssh/work_rsa',
        owner    => $chargeclient_owner,
        group    => $chargeclient_group,
        require  => [ File[$chargeclient_path], Class['mopensuse::packages::vcs'] ]
    }

    file { "${chargeclient_path}/configuration.ini":
        ensure  => link,
        target  => "${chargeclient_path}/configuration-dev.ini",
        require => Vcsrepo[$chargeclient_path]
    }
}
