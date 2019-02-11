node default {

    create_resources(
        'file',
        lookup(mopensuse::config::network_manager::files),
        {'ensure'  => 'present'}
    )

    Package<||> -> File<||> -> Service<||>
    File <| ensure == 'dir' |> -> File <| ensure == 'present' |>
}
