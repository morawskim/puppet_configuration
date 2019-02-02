node default {
    $packages = lookup(mopensuse::packages,  {merge => deep})
    package { 'openssh': * => $packages['openssh']}
    service { 'sshd': * => lookup('mopensuse::services')['sshd']}

    Augeas {
        require => [
            Package['openssh'],
        ]
    }

    augeas { 'sshd_config':
        context => '/files/etc/ssh/sshd_config',
        changes => [
            'set PermitRootLogin no',
            'set Protocol 2',
            'set PasswordAuthentication no'
        ],
        notify  => Service['sshd']
    }

    Package<||> -> File<||> -> Service<||>
    File <| ensure == 'dir' |> -> File <| ensure == 'present' |>
}
