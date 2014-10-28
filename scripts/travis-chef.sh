#!/bin/bash

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

set -eo pipefail

mkdir -p /tmp/vm-provisioning
cd /tmp/vm-provisioning

curl --retry 3 -L https://api.github.com/repos/ayufan/travis-cookbooks/tarball/osx | tar xv
mv ayufan-travis-cookbooks-* travis-cookbooks

cat <<EOF > solo.rb
root = File.expand_path(File.dirname(__FILE__))
file_cache_path File.join(root, "cache")
cookbook_path [ "$PWD/travis-cookbooks/ci_environment" ]
log_level :debug
log_location STDOUT
verbose_logging false
EOF

cat <<EOF > solo.json
{
  "travis_build_environment": {
  	"use_tmpfs_for_builds": false,
    "home": "/Users/travis",
    "group": "staff"
  },
  "rvm": {
    "default": "2.0.0",
    "rubies": [ {"name": "2.0.0"}, {"name": "2.1"}, {"name": "1.9.3"} ],
    "gems": [ "bundler", "rake", "cocoapods", "xcpretty" ]
  },
  "java": {
    "java_home": "/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home"
  },
  "run_list": [
  	"recipe[homebrew]",
  	"recipe[travis_build_environment::osx]",
  	"recipe[rvm::multi]",
  	"recipe[cocoapods]"
  ]
}
EOF

sudo chef-solo -c solo.rb -j solo.json
rm -rf /tmp/vm-provisioning
