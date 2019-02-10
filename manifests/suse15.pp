node default {
   include mopensuse::zypper::refresh
#    include mopensuse::services::snapd

   class {'firewalld':
   }

#    class {'ca_cert':
#    }

   $rpmkeys = lookup(mopensuse::rpmkeys)
   rpmkey {'devel_tools': * => $rpmkeys['devel_tools']}
   rpmkey {'google_chrome': * =>  $rpmkeys['google_chrome']}
   rpmkey {'kde_extra': * => $rpmkeys['kde_extra']}
   rpmkey {'morawskim': * =>  $rpmkeys['morawskim']}
   rpmkey {'obs_morawskim': * => $rpmkeys['obs_morawskim']}
   rpmkey {'packman': * => $rpmkeys['packman']}
   rpmkey {'security_privacy': * => $rpmkeys['security_privacy']}
   rpmkey {'skype': * => $rpmkeys['skype']}
   rpmkey {'system_snappy': * => $rpmkeys['system_snappy']}
   rpmkey {'utilities': * => $rpmkeys['utilities']}
   rpmkey {'vivaldi': * => $rpmkeys['vivaldi']}
   rpmkey {'yarn': * => $rpmkeys['yarn']}

   $zypprepos = lookup(mopensuse::zypprepos, {merge => deep})
   zypprepo { 'devel_tools': * => $zypprepos['devel_tools']}
   zypprepo { 'google_chrome': * => $zypprepos['google_chrome']}
   zypprepo { 'kde_extra': * => $zypprepos['kde_extra']}
   zypprepo { 'morawskim': * => $zypprepos['morawskim']}
   zypprepo { 'obs_morawskim': * => $zypprepos['obs_morawskim']}
   zypprepo { 'packman': * => $zypprepos['packman']}
   zypprepo { 'security_privacy': * => $zypprepos['security_privacy']}
   zypprepo { 'skype_stable': * => $zypprepos['skype_stable']}
   zypprepo { 'system_snappy': * => $zypprepos['system_snappy']}
   zypprepo { 'utilities': * => $zypprepos['utilities']}
   zypprepo { 'vivaldi': * => $zypprepos['vivaldi']}
   zypprepo { 'yarn': * => $zypprepos['yarn']}


   $packages = lookup(mopensuse::packages,  {merge => deep})
   $packages.each |String $key, Hash $attrs| {
       package {$key:
           * => $attrs
       }
   }

#    $printers = lookup(mopensuse::printers)
#    $printers.each |String $key, Hash $attrs| {
#        printer {$key:
#            * => $attrs
#        }
#    }
#
#    default_printer { lookup(mopensuse::default_printer):
#     ensure  => present,
#   }

    Rpmkey<||> -> Zypprepo<||> ~> Class['mopensuse::zypper::refresh']
    Zypprepo<||> -> Package<||>
    Package<||> -> Service<||>
    File <| ensure == 'dir' |> -> File <| ensure == 'present' |>
    Printer<||> -> Default_printer<||>

    Package<|title == 'postfix'|> -> Package<|title == 'nullmailer'|>
    Package<|title == 'rsyslog'|> -> Package<|title == 'systemd-logger'|>
    Package<|title == 'kdeconnect-kde'|> -> Firewalld_service<|title == 'kdeconnect-kde'|>
}
