node default {

    include mopensuse::zypper::refresh
    include mopensuse::zypper::repositories::devel_tools
    include mopensuse::zypper::repositories::obs_morawskim
    include mopensuse::user::rpm
    include mopensuse::packages::rpmbuild

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"


    package { 'exim':
        ensure => absent
    }

    #libpng12-compat-devel vs libpng16-compat-devel
    package {['aspell-devel', 'autoconf', 'bison', 'curl', 'libcurl-devel',
        'cyrus-sasl-devel', 'libdb-4_8-devel', 'enchant-devel',
        'freetds-devel', 'freetype2-devel', 'gcc-c++', 'gd-devel', 'gmp-devel',
        'imap-devel', 'krb5-devel', 'libapparmor-devel', 'libbz2-devel',
        'libedit-devel', 'libevent-devel', 'libfbclient-devel', 'libicu-devel',
        'libjpeg62-devel', 'libopenssl-devel',
        'libtidy-devel', 'libtiff-devel', 'libxslt-devel',
        'libzip-devel', 'ncurses-devel', 'net-snmp-devel', 'openldap2-devel',
        'pam-devel', 'pcre-devel', 'pkg-config', 'systemd-devel',
        'libvpx-devel', 'libXft-devel', 'libXpm-devel', 'postfix',
        're2c', 'sqlite2-devel',
        'sqlite3-devel', 'tcpd-devel', 'unixODBC-devel', 'update-alternatives',
        'xorg-x11-devel', 'xz', 'git']:
        ensure  => present,
        require => Package['exim']
    }

    package { 'libmcrypt-devel':
      ensure  => present,
      require => Class['mopensuse::zypper::repositories::obs_morawskim'],
    }

    package { 'postgresql-devel':
        ensure  => present,
    }

    if ( ! defined(Package['libtool']) ) {
        package {'libtool':
            ensure => present
        }
    }

    if ( ! defined(Package['coreutils']) ) {
        package {'coreutils':
            ensure => present
        }
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
