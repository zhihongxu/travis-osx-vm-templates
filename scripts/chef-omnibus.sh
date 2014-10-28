#!/bin/bash

set -eo pipefail

# http://www.opscode.com/chef/install
curl -L https://www.opscode.com/chef/install.sh | bash /dev/stdin -v 11
