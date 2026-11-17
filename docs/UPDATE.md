# Updating and recovery

## Routine OpenWrt update

Build a new revision and copy its `*-squashfs-sysupgrade.bin` file to the
router. From OpenWrt, first validate without changing flash:

```sh
sysupgrade -T /tmp/openwrt-mediatek-filogic-keenetic_kn-4010-squashfs-sysupgrade.bin
```

If the check succeeds, retain configuration:

```sh
sysupgrade /tmp/openwrt-mediatek-filogic-keenetic_kn-4010-squashfs-sysupgrade.bin
```

To intentionally start with defaults, add `-n`. This update path writes only
the OpenWrt `kernel` and `ubi` partitions within `firmware_1`; it must never
touch `firmware_2`.

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
