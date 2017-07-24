node default {
  #To create private key: `openssl genrsa -out domain.dev.key 2048`

    $fp = '/home/marcin/Dokumenty/CA/intermediate/puppet/csr/domain.dev.csr'

    x509_csr { "${fp}":
     ensure      => present,
     private_key => '/home/marcin/Dokumenty/CA/intermediate/puppet/keys/domain.dev.key',
     subject     => 'CN=domain.dev/O=Morawskim/L=Plock/ST=MAZ/C=PL'
       }

   x509_sig { '/home/marcin/Dokumenty/CA/intermediate/puppet/certs/domain.dev.crt':
     ensure      => present,
     csr => $fp,
     config     => '/home/marcin/Dokumenty/CA/intermediate/puppet/puppet.cnf',
     require => X509_csr["${fp}"]
       }
}
