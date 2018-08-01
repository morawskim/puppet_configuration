node default {
    include mopensuse::zypper::refresh

    $rpmkeys = lookup(mopensuse::rpmkeys)
    $rpmkeys.each |String $key, Hash $attrs| {
        rpmkey {$key:
            * => $attrs
        }
    }

    $zypprepos = lookup(mopensuse::zypprepos, {merge => deep})
    $zypprepos.each |String $key, Hash $attrs| {
        zypprepo {$key:
            * => $attrs
        }
    }

    package {['yadm']:
        ensure => 'present',
    }
    Rpmkey<||> -> Zypprepo<||> ~> Class['mopensuse::zypper::refresh']
    Zypprepo<||> -> Package<||>
    
#     $a = lookup('mopensuse::zypprepos')
#     notify { $a['security_tools']['enabled']:
#     }
}
