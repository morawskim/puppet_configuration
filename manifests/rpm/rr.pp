node default {

    include mopensuse::zypper::refresh
    include mopensuse::zypper::repositories::devel_tools
    include mopensuse::zypper::repositories::morawskim
    include mopensuse::zypper::repositories::server_monitoring
    include mopensuse::user::rpm
    include mopensuse::packages::rpmbuild
    include mopensuse::packages::vcs

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"


    package {['ccache']:
        ensure  => present,
        require => Class['mopensuse::zypper::repositories::devel_tools']
    }

    package { ['cmake', 'python-pexpect', 'gdb', 'libstdc++-devel',
        'zlib-devel', 'man-pages', 'glibc-devel', 'gcc-c++', 'gcc', 'make']:
        ensure  => present,
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

}