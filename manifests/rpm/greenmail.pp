node default {

    include mopensuse::zypper::refresh
    include mopensuse::user::rpm
    include mopensuse::packages::rpmbuild
    include mopensuse::packages::vcs
    include mopensuse::zypper::repositories::devel_tools_building

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"

    package { ['java-1_8_0-openjdk', 'java-1_8_0-openjdk-devel']:
        ensure  => 'present',
    }

    package { 'maven':
        ensure  => 'present',
        require => Class['mopensuse::zypper::repositories::devel_tools_building']
    }

    vcsrepo { $rpmbuild_top:
        ensure   => present,
        provider => git,
        source   => hiera('morawskim_repository_url', 'git://github.com/morawskim/rpmbuild.git'),
        revision => "openSUSE_${::operatingsystemrelease}",
        owner    => 'rpm',
        group    => 'users',
        require => [ Class['mopensuse::user::rpm'], Package['git'] ]
    }
}
