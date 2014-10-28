#!/bin/sh
date > /etc/box_build_time
OSX_VERS=$(sw_vers -productVersion | awk -F "." '{print $2}')

# Set computer/hostname
COMPNAME=osx-10_${OSX_VERS}
scutil --set ComputerName ${COMPNAME}
scutil --set HostName ${COMPNAME}.vagrantup.com

# Packer passes boolean user variables through as '1', but this might change in
# the future, so also check for 'true'.
if [ "$INSTALL_VAGRANT_KEYS" = "true" ] || [ "$INSTALL_VAGRANT_KEYS" = "1" ]; then
	echo "Installing vagrant keys for $USERNAME user"
	mkdir "/Users/$USERNAME/.ssh"
	chmod 700 "/Users/$USERNAME/.ssh"
	curl -L 'https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub' > "/Users/$USERNAME/.ssh/authorized_keys"
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDgaCsUbzrttsYlizd70uHYIVanbZW81LwCrOX9DK7OwyzUdN0c1+mAzon+nkuWNzraiiNS400V2EsSMpPhMHBMON34b4HK4YSJHCNupOKLrYa/M8DYsjh4BQ8/a+6KneUCG94zhVWwioTCKJZqEYtlGrswGE2LGjpFcfWmMaSioOLgSeUtx0SwsOETQEmyZFjTdxc0iXNjzlk8eAeOZ+euM/cjocOymmsP+YM+gBV06fx1hueNzGAdRx87BHB6gW5PgjZOQ67wk5iCrvivgOmO8Lt/epVWmg5pA6Kq6nsKDyjGD9bZLyI7Aqhwg6dnvGKc9NQ6euaNul8fDkaXMVrr travis" >> "/Users/$USERNAME/.ssh/authorized_keys"
	chmod 600 "/Users/$USERNAME/.ssh/authorized_keys"
	chown -R "$USERNAME" "/Users/$USERNAME/.ssh"
fi

# Create a group and assign the user to it
dseditgroup -o create "$USERNAME"
dseditgroup -o edit -a "$USERNAME" "$USERNAME"
