# OpenWrt для Keenetic Racer KN-4010

[English version](README.en.md)

Неофициальный порт OpenWrt 25.12-SNAPSHOT для **Keenetic Racer (KN-4010)**.
Это роутер на MediaTek MT7981B с 512 МБ оперативной памяти, SPI-NAND на
128 МБ, двумя гигабитными портами и Wi-Fi 6 на MT7915.

Я делал этот порт на реальном Racer, поэтому здесь нет обещаний по чужим
платам. Мы оставили OpenWrt в первом слоте, а штатный KeeneticOS во втором.
Если эксперимент с основным образом не удался, через UART можно выбрать
сохранённый слот и вернуть роутер в рабочее состояние.

## Что уже работает

- загрузка OpenWrt из `firmware_1`;
- WAN на встроенном PHY MT7981;
- LAN 1 Гбит/с через Airoha AN8801SB;
- 2.4 и 5 ГГц Wi-Fi;
- DHCP, SSH и LuCI по HTTPS;
- UART-консоль 115200 8N1.

Передние индикаторы пока не поддержаны. В штатной прошивке ими занимается
закрытый драйвер PHR, а назначение GPIO для этой платы ещё не найдено. Пины
наугад не перебираются: рядом находятся линии SPI-NAND, Ethernet и Wi-Fi.

## Что лежит в репозитории

| Путь | Содержимое |
| --- | --- |
| `patches/` | Патчи для закреплённого коммита OpenWrt `60c494a...` |
| `config/kn4010.config` | Минимальная конфигурация образа с LuCI HTTPS |
| `scripts/prepare-source.sh` | Чистый checkout, feeds и применение патчей |
| `scripts/build.sh` | Сборка образов KN-4010 |
| `docs/УСТАНОВКА.md` | Первая установка по UART и TFTP |
| `docs/ОБНОВЛЕНИЕ.md` | Обновление, сохранение настроек и возврат к KeeneticOS |

Здесь намеренно нет дампов штатной прошивки, RF-EEPROM, серийных данных,
паролей, ключей и готовых образов. Они принадлежат конкретному устройству или
быстро устаревают.

## Сборка

Нужна Linux-система, Linux VM, контейнер или GitHub Actions. Системные `make`,
`awk` и Bash из macOS для OpenWrt 25.12 не годятся.

```sh
git clone https://github.com/grachevvladislav/openwrt-keenetic-kn-4010.git
cd openwrt-keenetic-kn-4010
./scripts/prepare-source.sh
./scripts/build.sh
```

Готовые файлы появятся в
`openwrt-25.12/bin/targets/mediatek/filogic/`.

Перед первой записью прочитай [инструкцию по установке](docs/УСТАНОВКА.md).
Для уже работающего OpenWrt есть [отдельная инструкция по обновлению](docs/ОБНОВЛЕНИЕ.md).

## Поиск по проекту

`OpenWrt`, `Keenetic Racer`, `KN-4010`, `MT7981`, `Filogic`, `AN8801SB`,
`Airoha PHY`, `UART`, `TFTP`, `sysupgrade`.
