#!/bin/bash

set -eo pipefail

: | sudo -u travis -H ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

sudo -u travis -H /bin/bash --login -c \
	'brew install xctool boost gcc wget cmake mercurial subversion'
