# Travis-CI compatible OS X VM for Packer

This is a set of Packer templates and support scripts that will prepare an OS X installer media that performs an unattended install for use with [Packer](http://packer.io). These were originally developed for VeeWee, but support for the VeeWee template has not been maintained since Packer's release and so it is only provided for historical purposes.

The machine is also configured for use with Travis-CI compatible CI for iOS continous integration: https://github.com/ayufan/gitlab-ci.

Provisioning steps that are defined in the template via items in the [scripts](https://github.com/ayufan/osx-vm-templates/tree/master/scripts) directory:
- VM guest tools installation if on VMware or Parallels
- Xcode CLI tools installation
- Chef installation via the [Opscode Omnibus installer](http://www.opscode.com/chef/install)
- Install brew with `xctool boost gcc wget cmake mercurial subversion`
- Install rvm
- Install all updates
- Install all dmg's found in `packages-VM-NAME` folder
- Enable development tools
- Automatically accept Xcode license and install simulators for all Xcode versions
- Add user `travis` with password `travis` and identity key: https://github.com/ayufan/gitlab-ci-runner/tree/topic/runner/lib/support/ssh
- Install customsshd daemon to fix problems with iOS 8.0 simulator on Xcode 6.0, 6.1 and 6.2 as described in: https://github.com/facebook/xctool/issues/404 and https://gist.github.com/xfreebird/93901ce603cbe087329e
- Install [travis-cookbooks](https://github.com/ayufan/travis-cookbooks/tree/osx) for `travis` user.

It's tested to work on 10.9.x (Mavericks) with Xcode 5.1, 6.0 and 6.1.

## Dependencies

You will require to have valid Apple Developer Account:

### Xcode 5.1

Download Xcode 5.1 from http://adcdownload.apple.com/Developer_Tools/xcode_5.1.1/xcode_5.1.1.dmg and put it into `packages-osx-xcode-5.1/`.

### Xcode 6.0

Download Xcode 6.0 from http://adcdownload.apple.com/Developer_Tools/xcode_6.0.1/xcode_6.0.1.dmg and put it into `packages-osx-xcode-6.0/`.

### Xcode 6.1

Download Xcode 6.1 from http://adcdownload.apple.com/Developer_Tools/xcode_6.1.1/xcode_6.1.1.dmg and put it into `packages-osx-xcode-6.1/`.

### Xcode 6.2 (beta5)

Download Xcode 6.2 from http://adcdownload.apple.com//Developer_Tools/Xcode_6.2_beta_5/Xcode_6.2_beta_5.dmg and put it into `packages-osx-xcode-6.2/`.

### Xcode 6.3 (beta)

Download Xcode 6.3 from http://adcdownload.apple.com//Developer_Tools/Xcode_6.3_beta/Xcode_6.3_beta.dmg and put it into `packages-osx-xcode-6.3/`.

## Preparing the ISO

OS X's installer cannot be bootstrapped as easily as can Linux or Windows, and so exists the [prepare_iso.sh](https://github.com/timsutton/osx-vm-templates/blob/master/prepare_iso/prepare_iso.sh) script to perform modifications to it that will allow for an automated install and ultimately allow Packer and later, Vagrant, to have SSH access.

Run the `prepare_iso.sh` script with two arguments: the path to an `Install OS X.app` or the `InstallESD.dmg` contained within, and an output directory. Root privileges are required in order to write a new DMG with the correct file ownerships. For example, with a 10.9.5 Mavericks installer:

`sudo prepare_iso/prepare_iso.sh "/Applications/Install OS X Mavericks.app" out`

...should output progress information ending in something this:

```
-- MD5: dc93ded64396574897a5f41d6dd7066c
-- Done. Built image is located at out/OSX_InstallESD_10.9.5_12E55.dmg. Add this iso and its checksum to your template.
```

## Build OSX image with Packer

The path and checksum can now be added to your Packer template or provided as [user variables](http://www.packer.io/docs/templates/user-variables.html). The `packer` directory contains a template that can be used with the `vmware-iso`, `virtualbox-iso` and `parallels-iso` builders.

The Packer template adds some additional VM options required for OS X guests. Note that the paths given in the Packer template's `iso_url` builder key accepts file paths, both absolute and relative (to the current working directory).

Given the above output, we could run then run packer:

```sh
cd packer
packer build \
  -var iso_checksum=dc93ded64396574897a5f41d6dd7066c \
  -var iso_url=../out/OSX_InstallESD_10.8.4_12E55.dmg \
  -var vm_name=osx-xcode-6.1 \
  template.json
```

You might also use the `-only` option to restrict to either the `vmware-iso`, `virtualbox-iso` or `parallels-iso` builders.

### For example if you want to build OSX for Parallels with Xcode 6.1 type:

```sh
cd packer
packer build \
  -var iso_checksum=dc93ded64396574897a5f41d6dd7066c \
  -var iso_url=../out/OSX_InstallESD_10.8.4_12E55.dmg \
  -var vm_name=osx-xcode-6.1 \
  -only parallels-iso \
  template.json
```

## Supported guest OS versions

Currently the prepare script supports Mavericks and Yosemite.

## License

MIT
