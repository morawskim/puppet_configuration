node default {
    create_resources(
        'file',
        lookup(mopensuse::user::config::files::files),
        {'ensure'  => 'present'}
    )

    create_resources(
        'file',
        lookup(mopensuse::user::config::dirs::dirs),
        {'ensure'  => 'directory'}
    )

    File <| ensure == 'directory' |> -> File <| ensure == 'present' |>
}
