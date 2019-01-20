node default {

    create_resources(
        'file',
        lookup(mopensuse::config::osc::files),
        {'ensure'  => 'present'}
    )

    $packages = lookup(mopensuse::packages,  {merge => deep})
    package { 'osc': * => $packages['osc']}
    group { 'osc':
        ensure => 'present',
        system => true,
    }

    Package<|title == 'osc'|> -> Group<||>
    Package<||> -> File<||> -> Service<||>
    File <| ensure == 'dir' |> -> File <| ensure == 'present' |>
}
