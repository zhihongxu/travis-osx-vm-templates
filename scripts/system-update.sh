if [ "$UPDATE_SYSTEM" == "true" ] || [ "$UPDATE_SYSTEM" == "1" ]; then
	echo "Downloading and installing system updates..."
	softwareupdate -i -a
fi

if [ "$DISABLE_AUTOUPDATES" == "true" ] || [ "$DISABLE_AUTOUPDATES" == "1" ]; then
	echo "Disable automatic updates..."
	softwareupdate --schedule off
fi
