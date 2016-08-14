node default {

    include mopensuse::zypper::refresh
    include mopensuse::zypper::repositories::devel_tools
    include mopensuse::user::rpm
    include mopensuse::packages::rpmbuild

    $rpm_home=$::mopensuse::user::rpm::user_home_path
    $rpmbuild_top="${rpm_home}/rpmbuild"

    exec { 'zypper_update':
        command => '/usr/bin/zypper --non-interactive --no-color update', 
        require => Class['mopensuse::zypper::refresh'] 
    }

    package { 'exim':
        ensure => absent
    }

    #libpng12-compat-devel vs libpng16-compat-devel
    package {['aspell-devel', 'autoconf', 'bison', 'curl', 'libcurl-devel',
        'cyrus-sasl-devel', 'libdb-4_8-devel', 'enchant-devel', 'firebird-devel',
        'freetds-devel', 'freetype2-devel', 'gcc-c++', 'gd-devel', 'gmp-devel',
        'imap-devel', 'krb5-devel', 'libapparmor-devel', 'libbz2-devel',
        'libedit-devel', 'libevent-devel', 'libfbclient2-devel', 'libicu-devel',
        'libjpeg62-devel', 'libmcrypt-devel', 'libopenssl-devel',
        'libtidy-0_99-0-devel', 'libtiff-devel', 'libxslt-devel',
        'libzip-devel', 'ncurses-devel', 'net-snmp-devel', 'openldap2-devel',
        'pam-devel', 'pcre-devel', 'pkg-config', 'systemd-devel',
        'libvpx-devel', 'libXft-devel', 'libXpm-devel', 'postfix',
        're2c', 'sqlite2-devel',
        'sqlite3-devel', 'tcpd-devel', 'unixODBC-devel', 'update-alternatives',
        'xorg-x11-devel', 'xz', 'git']:
        ensure  => present,
        require => Package['exim']
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
        source   => 'https://github.com/morawskim/rpmbuild.git',
        revision => "openSUSE_${::operatingsystemrelease}",
        owner    => 'rpm',
        group    => 'users',
        require => [ Class['mopensuse::user::rpm'], Package['git'] ]
    }

    #TODO: XXX what if we will build package by jenkins?
    #$spec_file='php56.spec'
    #$build_log_path="${rpm_home}/build-$spec_file"
    #exec { 'build_rpm_package':
    #    command     => "/vagrant/build-spec.sh '$rpmbuild_top' '$spec_file' 2>&1 | tee $build_log_path",
    #    user        => 'rpm',
    #    path        => ['/usr/local/bin', '/usr/bin:/bin'],
    #    #logoutput   => true,
    #    timeout     => 0,
    #    environment => ["HOME=${rpm_home}"],
    #    require     => Vcsrepo[$rpmbuild_top] 
    #}
}