node default {

    include mopensuse::zypper::refresh
    include mopensuse::zypper::repositories::devel_tools
    include mopensuse::zypper::repositories::morawskim
    include mopensuse::zypper::repositories::server_monitoring
    include mopensuse::packages::devel-c-cpp
    include mopensuse::packages::devel-kde
    include mopensuse::packages::rpmbuild
    include mopensuse::packages::vcs
    include mopensuse::user::rpm

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"

    exec { 'zypper_update':
        command => '/usr/bin/zypper --non-interactive --no-color update',
        require => Class['mopensuse::zypper::refresh']
    }

    #cmake gcc-c++
    package { ['kopete-devel']:
      ensure => present
    }

    vcsrepo { $rpmbuild_top:
        ensure   => present,
        provider => git,
        source   => 'https://github.com/morawskim/rpmbuild.git',
        revision => "openSUSE_${::operatingsystemrelease}",
        owner    => 'rpm',
        group    => 'users',
        require => [ Class['mopensuse::user::rpm'], Package['git'] ]
    }

    # $facts['vagrant'] Only works with Puppet 3.5 or later.
    # Disabled by default in open source releases prior to Puppet 4.0.
    if $::vagrant {
        file {'/vagrant':
            ensure  => directory,
            mode    => '1775',
            owner   => 'vagrant',
            group   => 'users',
        }
    }
}