node default {

    create_resources(
        'file',
        lookup(mopensuse::config::dnsmasq::files),
        {'ensure'  => 'present'}
    )

    $packages = lookup(mopensuse::packages,  {merge => deep})
    package { 'dnsmasq': * => $packages['dnsmasq']}
    package { 'libcap-progs': * => $packages['libcap-progs']}
    service { 'dnsmasq': * => lookup('mopensuse::services')['dnsmasq']}

    file_capability { '/usr/sbin/dnsmasq':
        ensure     => present,
        capability => 'cap_net_bind_service=ep',
        require    => [
            Package['libcap-progs'],
            Package['dnsmasq']
        ],
    }

    Package<||> -> File<||> -> Service<||>
    File <| ensure == 'dir' |> -> File <| ensure == 'present' |>
}
