node default {

    include mopensuse::zypper::refresh
    include mopensuse::zypper::repositories::ruby_extensions
    include mopensuse::user::rpm
    include mopensuse::packages::rpmbuild

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"


    package {['rubygem-ronn', 'git']:
        ensure  => present,
        require => Class['mopensuse::zypper::repositories::ruby_extensions']
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