#!/bin/bash
# USB wakeup設定インストールスクリプト
# 実行: sudo bash system/install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: root権限が必要です。 sudo bash $0 で実行してください。" >&2
    exit 1
fi

echo "=== USB Wake-on-Input 設定インストール ==="

# udevルールをコピー
echo "[1/4] udevルールを配置..."
mkdir -p /etc/udev/rules.d
cp "$SCRIPT_DIR/udev/90-usb-wakeup.rules" /etc/udev/rules.d/
echo "  -> /etc/udev/rules.d/90-usb-wakeup.rules"

# スクリプトをコピー
echo "[2/4] スクリプトを配置..."
cp "$SCRIPT_DIR/scripts/enable-usb-wakeup.sh" /usr/local/bin/
chmod +x /usr/local/bin/enable-usb-wakeup.sh
echo "  -> /usr/local/bin/enable-usb-wakeup.sh"

# systemdサービスをコピー
echo "[3/4] systemdサービスを配置..."
cp "$SCRIPT_DIR/systemd/usb-wakeup.service" /etc/systemd/system/
echo "  -> /etc/systemd/system/usb-wakeup.service"

# 有効化
echo "[4/4] サービスを有効化..."
systemctl daemon-reload
systemctl enable --now usb-wakeup.service
udevadm control --reload-rules
udevadm trigger

echo ""
echo "=== インストール完了 ==="
echo ""
echo "確認コマンド:"
echo "  cat /proc/acpi/wakeup                      # ACPIwakeupソース確認"
echo "  systemctl status usb-wakeup.service        # サービス状態確認"
echo "  grep . /sys/bus/usb/devices/*/power/wakeup # USBデバイスwakeup状態"
echo ""
echo "テスト: systemctl suspend → マウス/キーボードで復帰"
