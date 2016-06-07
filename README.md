# vimconfig

An attempt to normalize my Vim configuration across machines. Incidentally
contains packages that are not vim now, but it still synchronizes my
configuration.

## Installation

```bash
git clone https://github.com/bertptrs/vimconfig.git
./vimconfig/install.sh
```

This will install the correct vimrc and load the packages mentioned in bundle.
There are some requirements:

* `stow` must be available.
* `gsettings` must be available. This currently does not block installation,
  but the installation will not be complete without it.
