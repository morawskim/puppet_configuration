node default {

    create_resources(
        'file',
        lookup(mopensuse::config::collectd::files),
        {'ensure'  => 'present'}
    )

    $packages = lookup(mopensuse::packages,  {merge => deep})
    package { 'collectd': * => $packages['collectd']}
    package { 'collectd-web': * => $packages['collectd-web']}
    package { 'perl-rrdtool':
      ensure => present
    }
    service { 'collectd': * => lookup('mopensuse::services')['collectd']}

    Package<||> -> File<||> -> Service<||>
    File <| ensure == 'dir' |> -> File <| ensure == 'present' |>
}
