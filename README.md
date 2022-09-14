# archer

Nerves Project on Beagle Bone Black

## Setup

I'm only going to describe the OSX setup here since that is what I use for my development
environment. If you are using a different platform, please reference the documentation referenced
below.

### Install Tools & Dependencies

First we need to install a view core utilities. This can easily be done via Homebrew.

```sh
$ brew update
$ brew install fwup squashfs coreutils xz pkg-config
```

### Beagle Bone Black eMMC update

#### Download Image
First download the latest image from [Beagle Board Website](https://beagleboard.org/latest-images)

#### Flash microSD
Once we have the image, we'll need to flash a 4GB microSD card with the image.

* Plug in your microSD card in you your Mac via USB.
* List the available attached devices

  ```sh
  $ diskutil list
  /dev/disk0 (internal, physical):
     #:                       TYPE NAME                    SIZE       IDENTIFIER
     0:      GUID_partition_scheme                        *500.3 GB   disk0
     1:                        EFI EFI                     314.6 MB   disk0s1
     2:                 Apple_APFS Container disk1         500.0 GB   disk0s2

  /dev/disk1 (synthesized):
     #:                       TYPE NAME                    SIZE       IDENTIFIER
     0:      APFS Container Scheme -                      +500.0 GB   disk1
                                   Physical Store disk0s2
     1:                APFS Volume Macintosh HD - Data     335.4 GB   disk1s1
     2:                APFS Volume Preboot                 876.9 MB   disk1s2
     3:                APFS Volume Recovery                1.1 GB     disk1s3
     4:                APFS Volume VM                      17.2 GB    disk1s4
     5:                APFS Volume Steam                   56.5 GB    disk1s5
     6:                APFS Volume Macintosh HD            15.4 GB    disk1s6
     7:              APFS Snapshot com.apple.os.update-... 15.4 GB    disk1s6s1

  /dev/disk2 (external, physical):
     #:                       TYPE NAME                    SIZE       IDENTIFIER
     0:     FDisk_partition_scheme                        *7.7 GB     disk2
     1:                      Linux                         3.8 GB     disk2s1
                      (free space)                         4.0 GB     -
  ```

  Here you can see that `/dev/disk2` is our device that we want to used for the new image.
  In the example above, I'm using a 8GB card. Only 3.8GB of the card will be used however.

* Make sure that any partitions are unmounted

  ```sh
  $ diskutil unmountDisk /dev/disk2s1
  ```

* Extract the image

  ```sh
  $ xz -d bone-eMMC-flasher-debian-10.3-iot-armhf-2020-04-06-4gb.img.xz
  ```

* Copy the image to the card

  ```sh
  $ sudo dd if=bone-eMMC-flasher-debian-10.3-iot-armhf-2020-04-06-4gb.img of=/dev/disk2 bs=1m
  ```

## Nerves Project Setup

### Clone the repository locally

```sh
$ git clone git@github.com:<your fork>/archer.git
```

### Elixir/Erlang install

We are going to use [asdf](https://asdf-vm.com) for managing our Erlang/Elixir depenedencies. If you have installed these
using Homebrew, you may have version conflicts.

```sh
$ brew uninstall elixir
$ brew uninstall erlang
```

Next we install `asdf` using Homebrew.

```sh
$ brew install asdf
```

We need to install the `erlang` and `elixir` plugins for `asdf`.

```sh
$ asdf plugin-add erlang
$ asdf plugin-add elixir
```

We manage the Elixir and OTP versions using the `.tool-versions` file in the repository, so we just
need to move in to the repository and install.

```sh
$ cd archer
$ asdf install
```

Next we need to make sure that `hex` and `rebar` are up to date.

```sh
$ mix local.hex
$ mix local.rebar
```

Lastly, we install the `nerves_boostrap` archive for environment.

```sh
$ mix archive.install hex nerves_bootstrap
```

# Reference

* [BBB Update Instructions](https://beagleboard.org/getting-started#update)
* [Nerves Installation](https://hexdocs.pm/nerves/installation.html)
* [asdf](https://asdf-vm.com)
