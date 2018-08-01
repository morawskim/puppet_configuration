
# run:
# 	FACTER_operatingsystemrelease="15.0" FACTER_operatingsystem="OpenSuSE" FACTER_osfamily="Suse" sudo -E /tmp/tmp.86E6gI5OSf/bin/puppet apply    --hiera_config=/vagrant/p/hiera-local.yaml --modulepath=/vagrant/p/modules/ /vagrant/p/manifests/suse15.pp
# 
# hiera5:
# 	FACTER_operatingsystemmajrelease=15 FACTER_operatingsystemrelease="15.0" FACTER_operatingsystem="OpenSuSE" FACTER_osfamily="Suse" sudo -E /tmp/tmp.86E6gI5OSf/bin/puppet apply   --hiera_config=/vagrant/p/hiera5.yaml --modulepath=/vagrant/p/modules/ /vagrant/p/manifests/suse15.pp
# 	
# marcin:
# 	FACTER_operatingsystemmajrelease=15 FACTER_operatingsystemrelease="15.0" FACTER_operatingsystem="OpenSuSE" FACTER_osfamily="Suse" sudo -E /tmp/tmp.86E6gI5OSf/bin/puppet apply   --hiera_config=/vagrant/p/hiera5.yaml --modulepath=/vagrant/p/modules/ /vagrant/p/manifests/marcin.pp

init:
	FACTER_operatingsystemmajrelease=15 FACTER_operatingsystemrelease="15.0" FACTER_operatingsystem="OpenSuSE" FACTER_osfamily="Suse" sudo -E /usr/local/share/puppet/bin/puppet apply   --hiera_config=hiera5.yaml --modulepath=modules/ manifests/init.pp

suse:
	FACTER_operatingsystemmajrelease=15 FACTER_operatingsystemrelease="15.0" FACTER_operatingsystem="OpenSuSE" FACTER_osfamily="Suse" sudo -E /usr/local/share/puppet/bin/puppet apply   --hiera_config=hiera5.yaml --modulepath=modules/ manifests/suse15.pp

marcin2:
	FACTER_operatingsystemmajrelease=15 FACTER_operatingsystemrelease="15.0" FACTER_operatingsystem="OpenSuSE" FACTER_osfamily="Suse" sudo -E /usr/local/share/puppet/bin/puppet apply   --hiera_config=hiera5.yaml --modulepath=modules/ manifests/marcin.pp

config:
	FACTER_operatingsystemmajrelease=15 FACTER_operatingsystemrelease="15.0" FACTER_operatingsystem="OpenSuSE" FACTER_osfamily="Suse" sudo -E /usr/local/share/puppet/bin/puppet apply   --hiera_config=hiera5.yaml --modulepath=modules/ manifests/config.pp

projekt:
	FACTER_operatingsystemmajrelease=15 FACTER_operatingsystemrelease="15.0" FACTER_operatingsystem="OpenSuSE" FACTER_osfamily="Suse" /usr/local/share/puppet/bin/puppet apply --hiera_config=hiera5.yaml --modulepath=modules/ manifests/projekty/${MANIFEST}
	

install:
	/usr/local/share/puppet/bin/librarian-puppet install

update:
	/usr/local/share/puppet/bin/librarian-puppet update puppet-mopensuse

lookup:
	/usr/local/share/puppet/bin/puppet lookup --hiera_config hiera5.yaml mopensuse::zypprepos
	
test:
	FACTER_operatingsystemmajrelease=15 FACTER_operatingsystemrelease="15.0" FACTER_operatingsystem="OpenSuSE" FACTER_osfamily="Suse" /usr/local/share/puppet/bin/puppet apply --debug --hiera_config=hiera5.yaml --modulepath=modules/ manifests/testy.pp

