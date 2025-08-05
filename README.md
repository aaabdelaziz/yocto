# Yocto Custom Image for Raspberry Pi 4

This repository contains a Yocto-based project to build a custom Linux image (`core-image-mycustom`) for the Raspberry Pi 4.  
The image here at that branch includes a basic image ready with useful tools like **SSH (Dropbear)**, **Python 3**, and **Vim**, built on top of the minimal Yocto image.

---

## 📦 Features

- 🐍 Python 3 support
- 🔐 SSH access via Dropbear
- 📝 Vim editor
- 🧼 Lightweight and production-ready base image

---

## 🚀 Quick Start Guide

### ✅ Requirements

- Ubuntu 20.04 or newer (or any Yocto-compatible Linux distro)
- `git`, `python3`, `gawk`, `wget`, `diffstat`, `chrpath`, `cpio`, `xz-utils`
- At least 100 GB free disk space
- Stable internet connection

Install required packages:

Either make it manual, or refer to script at Tools\setup_metalayers_kirkstone.sh
```bash
sudo apt update
sudo apt install gawk wget git-core diffstat unzip texinfo gcc-multilib      build-essential chrpath socat cpio python3 python3-pip python3-pexpect      xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa      libsdl1.2-dev pylint xterm
```



---

## 🔁 Clone this Repository

```bash
git clone https://github.com/aaabdelaziz/yocto.git
cd yocto-rpi-project
```

---

## 📥 Download Yocto and Required Layers

```bash
# Clone poky (Yocto core)
git clone -b kirkstone git://git.yoctoproject.org/poky

# Clone Raspberry Pi BSP layer
git clone -b kirkstone https://github.com/agherzan/meta-raspberrypi

# Clone meta-openembedded (for python3/vim etc.)
git clone -b kirkstone https://github.com/openembedded/meta-openembedded
```

Now your directory should look like:

```
yocto-rpi-project/
├── poky/
├── meta-raspberrypi/
├── meta-openembedded/
├── meta-network
└── build/
```

---

## ⚙️ Setup Environment

```bash
source poky/oe-init-build-env build
```

---

## 🔧 Configure Build

Edit `conf/bblayers.conf` to include your layers:

```conf
BBLAYERS ?= " \
  ${TOPDIR}/poky/poky/meta \
  ${TOPDIR}/poky/poky/meta-poky \
  ${TOPDIR}/poky/meta-raspberrypi \
  ${TOPDIR}/poky/meta-openembedded/meta-oe \
  ${TOPDIR}/poky/meta-openembedded/meta-python \
  ${TOPDIR}//poky/meta-openembedded/meta-networking 
"
```

Edit `conf/local.conf` if needed to append more features to this image like:

```conf
MACHINE = "raspberrypi4"
IMAGE_FEATURES:append = " ssh-server-dropbear"
IMAGE_INSTALL:append = " python3 vim"
```

---

## 🧱 Build the Custom Image

```bash
bitbake core-image-minimal
```

> Replace `core-image-minimal` with the actual name of your image `.bb` recipe.

---

## 💾 Flash the Image to SD Card

After the build, you’ll find the image here:

```
tmp/deploy/images/raspberrypi4/core-image-minimal-raspberrypi4-64.wic.bz2
```
- Define sdX of your SD card using lsblk, it will show you which partition name for SD card (root, boot).

- Flash it using `dd` or [balenaEtcher](https://www.balena.io/etcher/):

```bash
sudo dd if=core-image-minimal-raspberrypi4-64.wic.bz2 of=/dev/sdX bs=4M status=progress && sync
```

> Replace `/dev/sdX` with your actual SD card device (be careful!).

---

## 🔌 Boot the Pi

- Insert the SD card into Raspberry Pi 4
- Power it on
- Connect via serial or Ethernet and SSH

Default login:
- **User:** `root`
- **Password:** *(usually no password for root in Yocto minimal)*

---

## 📁 Project Structure

```
yocto-rpi-project/
├── build/                  # Build output and configs
│   └── conf/
│       ├── bblayers.conf
│       └── local.conf
.
.
├── poky/                   # Yocto base
├── meta-raspberrypi/       # BSP for Raspberry Pi
├── meta-openembedded/      # Extra packages (python3, etc.)
└── README.md
```

---

## 🧠 Tips

- To clean and rebuild the image:
  ```bash
  bitbake -c clean core-image-minimal
  bitbake core-image-minimal
  ```

- To add more packages, edit `local.conf` or create your own image recipe in `meta-custome-img`.

---