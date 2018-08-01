node default {
   include mopensuse::zypper::refresh

   class {'firewalld':
   }

   class {'ca_cert':
   }

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

   $packages = lookup(mopensuse::packages,  {merge => deep})
   $packages.each |String $key, Hash $attrs| {
       package {$key:
           * => $attrs
       }
   }

   $printers = lookup(mopensuse::printers)
   $printers.each |String $key, Hash $attrs| {
       printer {$key:
           * => $attrs
       }
   }

   default_printer { lookup(mopensuse::default_printer):
    ensure  => present,
  }

    Rpmkey<||> -> Zypprepo<||> ~> Class['mopensuse::zypper::refresh']
    Zypprepo<||> -> Package<||>
    Package<||> -> Service<||>
    Printer<||> -> Default_printer<||>
}
