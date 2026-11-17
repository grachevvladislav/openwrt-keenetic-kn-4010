# First installation

[Русская версия](УСТАНОВКА.md)

This method writes OpenWrt to `firmware_1` only and leaves the factory
KeeneticOS image in `firmware_2` intact. It requires a 3.3 V TTL UART adapter
and a TFTP server on a computer connected to the router's Ethernet port.

## Safety rules

- Use **3.3 V TTL**, never RS-232 and never connect the adapter's 3.3 V or 5 V
  power lead to the router.
- Connect `GND` to `GND`, adapter `RX` to router `TX`, and adapter `TX` to
  router `RX`.
- Do not erase or write `Preloader`, `U-Boot`, `U-Config`, `RF-EEPROM`,
  `RF-EEPROM_res`, `reserved`, or `firmware_2`.
- A power loss during an erase/write can leave `firmware_1` unusable. The
  unmodified second slot and UART are the recovery path.

## Build and serve the image

Build the project as described in the README. Copy this exact file into the
root directory of a TFTP server:

```text
openwrt-mediatek-filogic-keenetic_kn-4010-squashfs-raw-slot.bin
```

Set the computer to `192.168.1.2/24`; do not set a gateway. The U-Boot defaults
are `ipaddr=192.168.1.1` and `serverip=192.168.1.2`.

## Write firmware_1 from U-Boot

At boot, enter **U-Boot console**. The following is a single-slot operation.
First download and validate the image:

```text
tftpboot 0x46000000 openwrt-mediatek-filogic-keenetic_kn-4010-squashfs-raw-slot.bin
iminfo 0x46000000
```

`iminfo` must report an `ARM64 OpenWrt FIT`. Then write the image. `${filesize}`
is set by `tftpboot`; do not replace it with a guessed number.

```text
nand erase 0x500000 0x3700000
nand write 0x46000000 0x500000 ${filesize}
crc32 0x46000000 ${filesize}
nand read 0x47000000 0x500000 ${filesize}
crc32 0x47000000 ${filesize}
iminfo 0x47000000
```

The two `crc32` values must be identical and `iminfo` must again identify the
OpenWrt FIT.

## Select OpenWrt as the active slot

The U-State partition starts at `0x3c00000`. Its first eight bytes are a small
dual-image state record. The following record is exactly `USTA`, version 1,
active slot **1** (OpenWrt), backup slot **2** (KeeneticOS), boot failures 0.

```text
mw.b 0x46000000 0x55 1
mw.b 0x46000001 0x53 1
mw.b 0x46000002 0x54 1
mw.b 0x46000003 0x41 1
mw.b 0x46000004 0x01 1
mw.b 0x46000005 0x01 1
mw.b 0x46000006 0x02 1
mw.b 0x46000007 0x00 1
nand erase 0x3c00000 0x80000
nand write 0x46000000 0x3c00000 0x8
reset
```

OpenWrt should boot. The default LAN address is `192.168.1.1`; set a root
password immediately. LuCI is available at `https://192.168.1.1/`.
