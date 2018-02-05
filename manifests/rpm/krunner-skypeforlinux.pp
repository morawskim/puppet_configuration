node default {

    include mopensuse::zypper::refresh
    include mopensuse::zypper::repositories::devel_tools
    include mopensuse::packages::rpmbuild
    include mopensuse::packages::vcs
    include mopensuse::packages::patterns_devel_c_cpp
    include mopensuse::user::rpm

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"

    package { ['extra-cmake-modules', 'cmake', 'gcc-c++']:
      ensure => present
    }

    package { ['krunner-devel', 'kpackage-devel', 'plasma-framework-devel', 'ktextwidgets-devel']:
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
