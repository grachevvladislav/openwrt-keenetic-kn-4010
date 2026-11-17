# Updating and recovery

[Русская версия](ОБНОВЛЕНИЕ.md)

## Routine OpenWrt update (no UART while OpenWrt boots)

When OpenWrt is reachable, update through **LuCI: System > Backup / Flash
Firmware** or over SSH. Upload only the `*-squashfs-sysupgrade.bin` image and
leave **Keep settings** enabled. UART is not needed for this normal path; it is
the recovery method if an update is interrupted or the device stops booting.

Build a new revision and copy its `*-squashfs-sysupgrade.bin` file to the
router. From OpenWrt, first validate without changing flash:

```sh
sysupgrade -T /tmp/openwrt-mediatek-filogic-keenetic_kn-4010-squashfs-sysupgrade.bin
```

If the check succeeds, retain configuration:

```sh
sysupgrade /tmp/openwrt-mediatek-filogic-keenetic_kn-4010-squashfs-sysupgrade.bin
```

To intentionally start with defaults, add `-n`. The image metadata and upgrade
layout are configured for the OpenWrt `kernel` and `ubi` partitions within
`firmware_1`; it must never touch `firmware_2`. The first real `sysupgrade` on
this port is still to be validated on hardware, so retain UART access and the
raw-slot image until that test has completed.

## What is retained

With the default `sysupgrade` invocation, OpenWrt backs up and restores its
configuration, including `/etc/config`, SSH keys and the files listed in
`/etc/sysupgrade.conf`. It does **not** preserve arbitrary files outside that
set.

Extra packages are not automatically copied or reinstalled: the root filesystem
is replaced. `sysupgrade -k` only puts a list of installed packages into the
backup; it does not restore them. Put required packages in the image build
configuration, or keep an explicit package list and install it again after the
update. This is especially important for packages with kernel-module
dependencies.

## UART/TFTP update path

If the running system is unavailable, use the raw-slot image and the U-Boot
download/verify/write commands in [INSTALL.md](INSTALL.md). This is also the
recommended path when changing flash-layout code.

## Boot the preserved KeeneticOS slot

Enter U-Boot console and select slot 2 by writing this U-State header, then
reset:

```text
mw.b 0x46000000 0x55 1
mw.b 0x46000001 0x53 1
mw.b 0x46000002 0x54 1
mw.b 0x46000003 0x41 1
mw.b 0x46000004 0x01 1
mw.b 0x46000005 0x02 1
mw.b 0x46000006 0x01 1
mw.b 0x46000007 0x00 1
nand erase 0x3c00000 0x80000
nand write 0x46000000 0x3c00000 0x8
reset
```

To return to OpenWrt, repeat the slot-selection block from INSTALL.md.

## Do not use these images interchangeably

- `raw-slot.bin`: only for U-Boot/TFTP direct writes at `0x500000`.
- `sysupgrade.bin`: only for `sysupgrade` on a running OpenWrt system.
- `initramfs-kernel.bin`: temporary RAM boot for development; it does not
  install OpenWrt.
