#!/bin/bash

set -eo pipefail

softwareupdate -i -a
softwareupdate --schedule off
