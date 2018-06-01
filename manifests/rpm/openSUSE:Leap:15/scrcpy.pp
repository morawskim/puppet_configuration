node default {

    include mopensuse::zypper::refresh
    include mopensuse::user::rpm
    include mopensuse::packages::rpmbuild
    include mopensuse::packages::vcs
    include mopensuse::zypper::repositories::games
    include mopensuse::zypper::repositories::obs_morawskim

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"

    package {['libSDL2-devel']:
        ensure  => present,
        require => Class['mopensuse::zypper::repositories::games']
    }

    package {['ffmpeg2-devel']:
        ensure  => present,
        require => Class['mopensuse::zypper::repositories::obs_morawskim']
    }

    package {['meson', 'ninja', 'gcc']:
        ensure  => present,
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
