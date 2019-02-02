node default {

    create_resources(
        'file',
        lookup(mopensuse::config::nullmailer::files),
        {'ensure'  => 'present'}
    )

    $packages = lookup(mopensuse::packages,  {merge => deep})
    package { 'nullmailer': * => $packages['nullmailer']}
    service { 'nullmailer': * => lookup('mopensuse::services')['nullmailer']}

    Package<||> -> File<||> -> Service<||>
    File <| ensure == 'dir' |> -> File <| ensure == 'present' |>
}
