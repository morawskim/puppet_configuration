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


    #cmake gcc-c++
    package { ['kopete-devel']:
      ensure => present
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