# OpenWrt for Keenetic Racer KN-4010

Reproducible OpenWrt 25.12-SNAPSHOT support for the **Keenetic Racer (KN-4010)**.

This port targets a MediaTek MT7981B router with 512 MiB RAM, 128 MiB SPI-NAND,
two Ethernet ports, MT7915 Wi-Fi and an Airoha AN8801SB LAN PHY.

## Status

Working and verified on hardware:

- UART console at 115200 8N1;
- boot from `firmware_1`;
- WAN (internal MT7981 PHY);
- LAN at 1 Gb/s (AN8801SB, including the PHY power-down workaround);
- 2.4 and 5 GHz Wi-Fi;
- DHCP, LuCI and SSH.

The second 55 MiB firmware slot (`firmware_2`) is deliberately preserved as
KeeneticOS recovery. Front-panel LEDs are not implemented: the vendor image
uses a proprietary PHR peripheral driver and their GPIO assignment has not yet
been established. Do not guess GPIOs.

## What is in this repository

- `patches/`: patches for exactly OpenWrt commit
  `60c494ad065fe3fcaeadf0e9ff4a8a2dc6e6be43`;
- `config/kn4010.config`: small reproducible image configuration, including
  LuCI with HTTPS;
- `scripts/prepare-source.sh`: checks out the pinned OpenWrt source and applies
  every patch;
- `scripts/build.sh`: builds the images;
- `docs/INSTALL.md`: first installation, through UART and TFTP;
- `docs/UPDATE.md`: routine updates and recovery.

No vendor firmware dump, RF calibration data, router configuration, keys,
passwords or generated images are committed.

## Quick build

On Linux (or a case-sensitive Linux VM/container), install the normal OpenWrt
build prerequisites, then run:

```sh
git clone https://github.com/grachevvladislav/openwrt-keenetic-kn-4010.git
cd openwrt-keenetic-kn-4010
./scripts/prepare-source.sh
./scripts/build.sh
```

The release files are written to
`openwrt-25.12/bin/targets/mediatek/filogic/`.

Read [the first-install guide](docs/INSTALL.md) before connecting UART or
writing flash.
