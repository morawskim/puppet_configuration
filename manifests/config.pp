node default {
    include mopensuse::config::osc
    include mopensuse::packages::osc
    
    include mopensuse::packages::docker
    include mopensuse::packages::sshfs
    include mopensuse::packages::git_server

    include mopensuse::config::cgit
    include mopensuse::config::apache2::custom
    include mopensuse::config::apache2::modules
    include mopensuse::config::dnsmasq
    include mopensuse::config::git_server
    include mopensuse::config::mysql
    include mopensuse::config::nfs_server
    include mopensuse::config::pam
    include mopensuse::config::sysctl
    include mopensuse::config::redis
    include mopensuse::config::phpldapadmin 
    include mopensuse::config::phpmyadmin
#     include mopensuse::config::phpmyadmin40
    include mopensuse::config::nullmailer
    include mopensuse::config::network_manager
    
    include mopensuse::services::mongodb
}
