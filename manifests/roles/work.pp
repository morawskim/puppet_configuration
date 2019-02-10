node default {
    include mopensuse::zypper::refresh

    $rpmkeys = lookup(mopensuse::rpmkeys)
    rpmkey {'nvidia': * => $rpmkeys['nvidia']}

    $zypprepos = lookup(mopensuse::zypprepos, {merge => deep})
    zypprepo { 'nvidia': * => $zypprepos['nvidia']}

#     package {'x11-video-nvidiaG03':
#         ensure => 'present'
#     }

    Rpmkey<||> -> Zypprepo<||> ~> Class['mopensuse::zypper::refresh']
    Zypprepo<||> -> Package<||>
    Package<||> -> Service<||>
    File <| ensure == 'dir' |> -> File <| ensure == 'present' |>
    Printer<||> -> Default_printer<||>
}
