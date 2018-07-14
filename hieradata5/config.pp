mopensuse::user::config::vim::vcsrepo:
  '/home/vagrant/.config/vim':
      path       : '/home/vagrant/.config/vim'
      ensure     : last
      provider   : git
      source     : 'git@github.com:morawskim/vimdot.git'
      submodules : true

mopensuse::user::config::vim::files:
  vimrc:
      path    : '/home/vagrant/.vimrc'
      ensure  : link
      target  : "/home/vagrant/.config/vim/vimrc"
  gvim:
      path    : '/home/vagrant/.gvimrc'
      ensure  : link
      target  : "/home/vagrant/.config/vim/vimrc"

#account
mopensuse::user::marcin::password: 'secret'
mopensuse::user::marcin::username: 'marcin'
mopensuse::user::marcin::user_home_path: '/home/marcin'
mopensuse::user::marcin::realname: 'Marcin Morawski'
mopensuse::user::marcin::groups:
  - www
  - vboxusers
  - vagrant
  - users
  - systemd-journal
  - sshfs
  - docker
  - disk
  - dialout
  - osc
  
