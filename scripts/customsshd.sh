#!/bin/bash

chmod +x "$HOME/customsshd"
sudo -u "$USERNAME" -H /bin/bash --login -c '$HOME/customsshd install'
