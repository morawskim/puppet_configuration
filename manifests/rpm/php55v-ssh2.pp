node default {

    include mopensuse::zypper::refresh
    include mopensuse::zypper::repositories::devel_tools
    include mopensuse::zypper::repositories::morawskim
    include mopensuse::user::rpm
    include mopensuse::packages::rpmbuild
    include mopensuse::packages::vcs

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"


    package {['php55v', 'php55v-devel']:
        ensure  => present,
        require => Class['mopensuse::zypper::repositories::morawskim']
    }

    if $::operatingsystemrelease > 13.2 {
        include mopensuse::zypper::repositories::devel_languages_c_cpp
        package {['libssh2-devel']:
          ensure  => latest,
          install_options => [ {'--from' => 'devel_libraries_c_cpp'}, '--force' ],
        }

        package {['libssh2-1']:
          ensure  => latest,
          install_options => [ {'--from' => 'devel_libraries_c_cpp'}, '--force' ],
          require => Class['mopensuse::zypper::repositories::devel_libraries_c_cpp'],
          before  => Package['libssh2-devel']
        }
    } else {
        include mopensuse::zypper::repositories::server_php_extensions

        package {['libssh2-devel']:
          ensure  => latest,
          install_options => [ {'--from' => 'server_php_extensions'}, '--force' ],
        }

        package {['libssh2-1']:
          ensure  => latest,
          install_options => [ {'--from' => 'server_php_extensions'}, '--force' ],
          require => Class['mopensuse::zypper::repositories::server_php_extensions'],
          before  => Package['libssh2-devel']
        }
    }

    vcsrepo { $rpmbuild_top:
        ensure   => present,
        provider => git,
        source   => hiera('morawskim_repository_url', 'git://github.com/morawskim/rpmbuild.git'),
        revision => "openSUSE_${::operatingsystemrelease}",
        owner    => 'rpm',
        group    => 'users',
        require => [ Class['mopensuse::user::rpm'], Class['mopensuse::packages::vcs'] ]
    }

}