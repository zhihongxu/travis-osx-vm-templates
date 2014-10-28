#!/bin/bash

set -eo pipefail

curl -sSL https://get.rvm.io | sudo -u "$USERNAME" -H bash -s stable
