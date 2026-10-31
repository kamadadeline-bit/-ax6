# Redmi AX6 Campus SY Firmware

独立的 Redmi AX6 校园网固件仓库。设备目标固定为 Qualcomm IPQ807x / `redmi_ax6`，不复用 NX30 Pro 的设备树、无线驱动或刷机布局。

## 构建

GitHub Actions: `.github/workflows/build-ax6.yml`。单 job 构建并启用 concurrency 锁，避免并行构建。手动运行可选择 LEDE 和 UA3F ref。

## 固件

- 原生 U-Boot 镜像：`factory.ubi`
- 同内容便捷副本：`redmi_ax6-campus-factory.bin`（必须与 factory.ubi 字节完全一致）
- OpenWrt 升级包：`sysupgrade.bin`
- 校验清单：`SHA256SUMS`

构建脚本会检查 AX6 profile、sysupgrade tar 中的 kernel/root、UBI# magic、参考镜像尺寸、factory.bin 与 factory.ubi 一致性，并验证 SHA256。

## 校园网功能

MentoHUST、Dogcom、ESurfingClient C v2.2.1-r7、PPP/PPPoE 环境、wpad-openssl、UA3F nftables TPROXY、PassWall nftables、UU 游戏加速器、SQM、relayd 无线中继、STA 自动恢复、Argon 中文主题。

不包含 OpenClash、SSR-Plus、Mihomo、MiniEAP、Turbo ACC 和无关家用插件。

## 默认设置

LAN `192.168.5.1/24`，主机名 `Campus-SY`，DHCP 池 `192.168.5.100–192.168.5.249`，SSID `SHAYU` / `SHAYU-5G`。首次启动默认口令仅供部署使用，首次登录后必须修改。

## 安全说明

factory.ubi 的尺寸与 UBI 头检查是保守结构校验，不等同于实机刷写验证。不要覆盖 U-Boot/MIBIB 分区；先保留已知可启动镜像和原厂备份。

构建入口：GitHub Actions 的 Build Campus SY - Redmi AX6 工作流。
