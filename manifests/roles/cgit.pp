node default {

    create_resources(
        'file',
        lookup( mopensuse::config::cgit::files),
        {'ensure'  => 'present'}
    )

    $packages = lookup(mopensuse::packages,  {merge => deep})
    package { 'cgit': * => $packages['cgit']}
    package { 'cgit-filter-syntaxhiglight': * => $packages['cgit-filter-syntaxhiglight']}
    package { 'highlight': * => $packages['highlight']}
    host { lookup( mopensuse::config::cgit::cgit_host):
        ensure       => present,
        ip           => '127.0.0.1',
        host_aliases => lookup( mopensuse::config::cgit::cgit_host_aliases)
    }

    Package<||> -> File<||> -> Service<||>
    File <| ensure == 'dir' |> -> File <| ensure == 'present' |>
}
