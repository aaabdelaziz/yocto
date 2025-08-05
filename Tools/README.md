# 🛠️ Tools Directory - README

This `Tools/` directory contains helper shell scripts designed to automate common tasks related to setting up, building, and flashing Yocto images for Raspberry Pi. Each script simplifies a key step in the development workflow.

---

## 📄 Script Descriptions

### 1. `setup_metalayers_kirkstone.sh`

**Purpose:**  
Prepares your system before building Yocto by installing required packages and cloning the necessary meta-layers (e.g. `poky`, `meta-raspberrypi`, `meta-openembedded`, etc.) for the `kirkstone` branch.

**Usage:**

```bash
chmod +x setup_metalayers_kirkstone.sh
./setup_metalayers_kirkstone.sh
```

**What it does:**

- Installs build dependencies (e.g. `gawk`, `wget`, `diffstat`, `chrpath`, etc.)
- Clones the required layers for Raspberry Pi and sets up the recommended structure

---

### 2. `clean_sdcard.sh`

**Purpose:**  
Cleans and formats an SD card by wiping old partition tables and preparing it for a fresh image flash.

**Usage:**

```bash
chmod +x clean_sdcard.sh
sudo ./clean_sdcard.sh /dev/sdX
```

> 🔥 Replace `/dev/sdX` with your actual SD card device (e.g. `/dev/sdb`). Be **extremely careful** not to choose your main disk!

**What it does:**

- Unmounts SD card partitions (if mounted)
- Erases partition table using `dd`
- Syncs disk changes

---

### 3. `sd_card_setup.sh`

**Purpose:**  
Formats an SD card and creates new partitions (typically one FAT32 boot and one ext4 root) before writing the Yocto image.

**Usage:**

```bash
chmod +x sd_card_setup.sh
sudo ./sd_card_setup.sh /dev/sdX
```

> Again, replace `/dev/sdX` with the correct device name.

**What it does:**

- Partitions the SD card
- Formats the boot partition as FAT32
- Formats the root partition as ext4

---

## 📦 Typical Usage Flow

1. Run the meta-layer setup script:

    ```bash
    ./setup_metalayers_kirkstone.sh
    ```

2. Build the Yocto image (manual step using `bitbake`)

3. Prepare the SD card:

    ```bash
    ./clean_sdcard.sh /dev/sdX
    ./sd_card_setup.sh /dev/sdX
    ```

4. Flash the built image using `dd` or `balenaEtcher`

---

## ⚠️ Disclaimer

Use scripts that interact with block devices **at your own risk**. Always double-check the device path (`/dev/sdX`) before running these tools.

---

## 📁 Directory Structure

```
Tools/
├── clean_sdcard.sh                  # Erase old partitions
├── sd_card_setup.sh                # Format and partition the SD card
├── setup_metalayers_kirkstone.sh   # Clone layers and install dependencies
└── README.md                        # This file
```

---

Happy Building! 🚀
