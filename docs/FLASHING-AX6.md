# Redmi AX6 刷写前检查

1. 只选择本仓库 Actions 中由 `redmi_ax6` profile 生成的产物。
2. U-Boot 优先使用原生 `factory.ubi`；`redmi_ax6-campus-factory.bin` 必须是其逐字节副本。
3. 在刷写前运行 `sha256sum -c SHA256SUMS`。
4. `sysupgrade.bin` 仅用于已运行 OpenWrt/LEDE 的系统内升级。
5. 不要把 stock MIBIB、U-Boot 备份当作固件刷入，也不要覆盖这些引导分区。
6. 本构建做 UBI magic、尺寸、设备 profile 和 sysupgrade 结构检查；首次刷写仍应保留可恢复方式。
