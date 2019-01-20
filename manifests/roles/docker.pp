node default {

    create_resources(
        'file',
        lookup(mopensuse::config::docker::files),
        {'ensure'  => 'present'}
    )

    $packages = lookup(mopensuse::packages,  {merge => deep})
    package { 'docker': * => $packages['docker']}
    package { 'docker-bash-completion': * => $packages['docker-bash-completion']}
    package { 'docker-compose': * => $packages['docker-compose']}
    service { 'docker': * => lookup('mopensuse::services')['docker']}

    Package<||> -> File<||> -> Service<||>
    File <| ensure == 'dir' |> -> File <| ensure == 'present' |>
}
