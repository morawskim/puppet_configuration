node default {

    include mopensuse::zypper::refresh
    include mopensuse::zypper::repositories::devel_tools
    include mopensuse::zypper::repositories::morawskim
    include mopensuse::zypper::repositories::server_php_extensions
    include mopensuse::user::rpm
    include mopensuse::packages::rpmbuild
    include mopensuse::packages::vcs

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"

    exec { 'zypper_update':
        command => '/usr/bin/zypper --non-interactive --no-color update',
        require => Class['mopensuse::zypper::refresh']
    }

    package {['php54', 'php54-devel']:
        ensure  => present,
        require => Class['mopensuse::zypper::repositories::morawskim']
    }

    package {['libssh2-devel']:
        ensure  => latest,
        install_options => [ {'--from' => 'server_php_extensions'}, '--force' ],
    }

    package {['libssh2-1']:
        ensure  => latest,
        install_options => [ {'--from' => 'server_php_extensions'}, '--force' ],
        require => Class['mopensuse::zypper::repositories::server_php_extensions'],
        before  => Package['libssh2-devel']
    }

    vcsrepo { $rpmbuild_top:
        ensure   => present,
        provider => git,
        source   => 'https://github.com/morawskim/rpmbuild.git',
        revision => "openSUSE_${::operatingsystemrelease}",
        owner    => 'rpm',
        group    => 'users',
        require => [ Class['mopensuse::user::rpm'], Class['mopensuse::packages::vcs'] ]
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