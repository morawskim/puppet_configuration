node default {

    include mopensuse::zypper::refresh
    include mopensuse::user::rpm
    include mopensuse::packages::rpmbuild
    include mopensuse::packages::vcs
    include mopensuse::zypper::repositories::devel_languages_go
    include mopensuse::zypper::repositories::virtualization_containers

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"

    package {['go1.7', 'golang-packaging', 'glide']:
        ensure  => present,
        require => Class['mopensuse::zypper::repositories::devel_languages_go'],
    }

    package {'mercurial':
        ensure => present,
    }

    package {'golang-github-jteeuwen-go-bindata':
        ensure  => present,
        require => Class['mopensuse::zypper::repositories::virtualization_containers']
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
