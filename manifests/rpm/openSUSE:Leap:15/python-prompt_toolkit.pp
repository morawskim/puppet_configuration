node default {

    include mopensuse::zypper::refresh
    include mopensuse::user::rpm
    include mopensuse::packages::rpmbuild
    include mopensuse::packages::vcs
    include mopensuse::zypper::repositories::devel_languages_python
    include mopensuse::zypper::repositories::morawskim

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"


    package {['python-base', 'python-setuptools', 'python-devel']:
        ensure  => present
    }

    package {['python-Pygments', 'python-wcwidth', 'python-six']:
      ensure => present,
      require => Class['mopensuse::zypper::repositories::devel_languages_python']
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