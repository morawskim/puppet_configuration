node default {

    create_resources(
        'file',
        lookup(mopensuse::config::git_server::files),
        {'ensure'  => 'directory'}
    )

    $packages = lookup(mopensuse::packages,  {merge => deep})
    package { 'git-daemon': * => $packages['git-daemon']}
    service { 'git-daemon': * => lookup('mopensuse::services')['git-daemon']}

    Package<||> -> File<||> -> Service<||>
    File <| ensure == 'dir' |> -> File <| ensure == 'present' |>
}
