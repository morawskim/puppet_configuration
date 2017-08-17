node default {

  $username = 'marcin'
  $user_home_path = "/home/${username}"

  $kopete_account_id = hiera('mopensuse::user::marcin::kopete_account_id', '0000000')
  $kopete_exclude_connect = hiera('mopensuse::user::marcin::kopete_exclude_connect', 'false')
  $kopete_identity = hiera('mopensuse::user::marcin::kopete_identity', 'KM8ARYPIac')
  $kopete_password_is_wrong = hiera('mopensuse::user::marcin::kopete_password_is_wrong', 'false')
  $kopete_priority = hiera('mopensuse::user::marcin::kopete_priority', '1')
  $kopete_protocol = hiera('mopensuse::user::marcin::kopete_protocol', 'GaduProtocol')
  $kopete_remember_password = hiera('mopensuse::user::marcin::kopete_remember_password', 'true')
  $kopete_export_list_on_change = hiera('mopensuse::user::marcin::kopete_export_list_on_change', '1')
  $kopete_ignore_anons = hiera('mopensuse::user::marcin::kopete_ignore_anons', '0')
  $kopete_import_list_on_login = hiera('mopensuse::user::marcin::kopete_import_list_on_login', '1')
  $kopete_nick_name = hiera('mopensuse::user::marcin::kopete_nick_name', '')
  $kopete_use_dcc = hiera('mopensuse::user::marcin::kopete_use_dcc', 'enabled')
  $kopete_use_encrypted_connection = hiera('mopensuse::user::marcin::kopete_use_encrypted_connection', 'TLS_no')

#   include mopensuse::user::gem::librarian_puppet
#   include mopensuse::user::gem::pry
#   include mopensuse::user::gem::showterm
#   include mopensuse::user::gem::mdless
#   include mopensuse::user::gem::dockrails

#   include mopensuse::user::pip::mycli
  
   mopensuse::user::config::profile{$username:
     user           => $username,
     user_home_path => $user_home_path,
   }
   
#   mopensuse::user::config::project-dir{$username:
#     user           => $username,
#     user_home_path => $user_home_path,
#   }

#   mopensuse::user::config::mnt_dir{$username:
#     user           => $username,
#     user_home_path => $user_home_path,
#   }

  mopensuse::user::config::vim{$username:
    user    => $username,
    user_home_path => $user_home_path,
  }
  
#   mopensuse::user::config::owncloud{$username:
#     user                       => $username,
#     user_home_path             => $user_home_path,
#     owncloud_desktop_localpath => $owncloud_desktop_localpath,
#     owncloud_desktop_http_user => $owncloud_desktop_http_user,
#     owncloud_desktop_url       => $owncloud_desktop_url,
#     owncloud_desktop_user      => $owncloud_desktop_user,
#     require                    => Mopensuse::User::Account[$username]
#   }

  mopensuse::user::config::rpmbuild{$username:
    user           => $username,
    user_home_path => $user_home_path,
  }

#   mopensuse::user::config::kopete_gg{$username:
#     user                            => $username,
#     user_home_path                  => $user_home_path,
#     kopete_account_id               => $kopete_account_id,
#     kopete_exclude_connect          => $kopete_exclude_connect,
#     kopete_identity                 => $kopete_identity,
#     kopete_password_is_wrong        => $kopete_password_is_wrong,
#     kopete_priority                 => $kopete_priority,
#     kopete_protocol                 => $kopete_protocol,
#     kopete_remember_password        => $kopete_remember_password,
#     kopete_export_list_on_change    => $kopete_export_list_on_change,
#     kopete_ignore_anons             => $kopete_ignore_anons,
#     kopete_import_list_on_login     => $kopete_import_list_on_login,
#     kopete_nick_name                => $kopete_nick_name,
#     kopete_use_dcc                  => $kopete_use_dcc,
#     kopete_use_encrypted_connection => $kopete_use_encrypted_connection,
#   }

   mopensuse::user::config::konsole{$username:
     user_home_path     => $user_home_path,
     source_colorscheme => "file://$user_home_path/.local/share/konsole/Afterglow.colorscheme",
     font               => 'SauceCodePro Nerd Font,10,-1,5,50,0,0,0,0,0',
     wallpaper          => "${user_home_path}/Obrazy/solarized_darcula.jpg",
   }

   file { "${user_home_path}/.local/share/akregator/data/feeds.opml":
     ensure  => link,
     target  => "${user_home_path}/.local/share/feeds.opml",
   }

   # We can use syntax git_daemon_paths.morawskim.path only in hiera 2
   # Currently we have only hiera 1.3.4
   $git_daemon_paths = hiera('git_daemon_paths')
   file { "${git_daemon_paths['morawskim']['path']}/rpmbuild.git":
     ensure  => link,
     target  => "${user_home_path}/rpmbuild/.git",
   }

#    mopensuse::user::config::konsole_font{$username:
#      user => $username,
#      user_home_path => $user_home_path,
#      font => 'SauceCodePro Nerd Font,11,-1,5,50,0,0,0,0,0',
#    }

#   mopensuse::user::config::kwrite{$username:
#     user => $username,
#     user_home_path => $user_home_path,
#   }
# 
#   mopensuse::user::config::rbenv_gemset{$username:
#     user           => $username,
#     user_home_path => $user_home_path,
#   }
# 
#   mopensuse::user::config::krunner_kopete{$username:
#     user           => $username,
#     user_home_path => $user_home_path,
#   }
  
#   mopensuse::user::config::nss_mmo_ca{$username:
#     user           => $username,
#     user_home_path => $user_home_path,
#     #require certutil
#   }
# 
#   mopensuse::user::config::nss_morawskim_puppet_ca{$username:
#     user           => $username,
#     user_home_path => $user_home_path,
#     #require certutil
#   }
}
