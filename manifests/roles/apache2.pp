node default {

    create_resources(
        'file',
        lookup(mopensuse::config::apache2::custom::files),
        {'ensure'  => 'present'}
    )

    create_resources(
        'a2mod',
        lookup(mopensuse::config::apache2::modules),
        {'ensure'  => 'present'}
    )

    $packages = lookup(mopensuse::packages,  {merge => deep})
    package { 'apache2': * => $packages['apache2']}
    service { 'apache2': * => lookup('mopensuse::services')['apache2']}
    
    
    Package<||> -> A2mod<||> ~> Service<||>

    Package<||> -> File<||> -> Service<||>
    File <| ensure == 'dir' |> -> File <| ensure == 'present' |>
}

# exec { 'define_apache_ssl_flag':
#     command => 'a2enflag SSL',
#     path    => ['/usr/sbin/', '/usr/bin', '/bin'],
#     unless  => "grep -e '^APACHE_SERVER_FLAGS' /etc/sysconfig/apache2 | grep SSL",
#     require => [ Package['apache2'] ],
#     notify  => Class['mopensuse::services::apache2']
#   }
