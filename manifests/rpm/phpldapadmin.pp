node default {

    include mopensuse::zypper::refresh
    include mopensuse::user::rpm
    include mopensuse::packages::rpmbuild
    include mopensuse::packages::vcs

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"


    vcsrepo { $rpmbuild_top:
        ensure   => present,
        provider => git,
        source   => 'https://github.com/morawskim/rpmbuild.git',
        revision => "openSUSE_${::operatingsystemrelease}",
        owner    => 'rpm',
        group    => 'users',
        require => [ Class['mopensuse::user::rpm'], Package['git'] ]
    }

    package { ['coreutils', 'tar', 'bzip2']:
        ensure => present
    }

}