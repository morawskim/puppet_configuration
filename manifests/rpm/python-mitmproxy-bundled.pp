node default {

    include mopensuse::zypper::refresh
    include mopensuse::user::rpm
    include mopensuse::packages::rpmbuild
    include mopensuse::packages::vcs
    include mopensuse::zypper::repositories::devel-languages-python
    include mopensuse::zypper::repositories::server_monitoring

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"


    package {['python-base', 'python-setuptools',
      'python-devel', 'python-pip', 'python-virtualenv',
      'python-Sphinx', 'python-sphinxcontrib-documentedlist']:
        ensure  => present,
        require => Class['mopensuse::zypper::repositories::devel-languages-python']
    }

    package {'libffi-devel':
        ensure  => present,
        require => Class['mopensuse::zypper::repositories::server_monitoring']
    }

    package {['libopenssl-devel', 'libxml2-devel', 'libxslt-devel']:
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
