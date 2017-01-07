node default {

  $aliases = [{'alias' => '/path', 'path' => '/tmp/file'}]

  mopensuse::define::apache2_vhost { "/tmp/apache-puppet.dev.conf":
    server_name    => 'apache-puppet.dev',
    document_root  => '/aa/bb/cc',
    serveraliases  => ['aaa.dev', 'bbb.dev', 'ccc.dev'],
    php_fpm_socket => '/run/php7-fpm.sock',
    vhost_aliases  => $aliases,
    vhost_setenv   => ['EO_DEV 1', 'APPLICATION_ENV mmorawski'],
    vhost_proxy_pass => [
      {'path' => '/core', 'url'=> 'http://google.com/'}
    ]
  }
}