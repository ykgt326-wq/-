#!/bin/bash
# USBコントローラのACPI wakeupを有効化するスクリプト
# /proc/acpi/wakeup の XHC/EHC エントリを有効化し、
# 接続済みUSBデバイスのpower/wakeupも有効化する

# 注意: set -e は使用しない（grepのexit code 1でスクリプトが中断するため）
set -uo pipefail

WAKEUP_FILE="/proc/acpi/wakeup"

if [ ! -f "$WAKEUP_FILE" ]; then
    echo "WARNING: $WAKEUP_FILE not found, skipping ACPI wakeup setup" >&2
    exit 0
fi

# 有効化対象のUSBコントローラ名（XHC=USB3.x, EHC=USB2.0）
USB_CONTROLLERS=(XHC XHC0 XHC1 XHC2 XHC3 EHC1 EHC2 USB0 USB1 USB2 USB3 USB4 USBC XHCI)

for device in "${USB_CONTROLLERS[@]}"; do
    # マッチしない場合は continue（grep失敗でスクリプト中断しないよう || continue）
    line=$(grep "^${device}[[:space:]]" "$WAKEUP_FILE" 2>/dev/null) || continue
    # 3列目がStatus: "*enabled" または "*disabled"
    status=$(echo "$line" | awk '{print $3}')
    if [[ "$status" == *disabled* ]]; then
        echo "$device" > "$WAKEUP_FILE" && echo "Enabled ACPI wakeup: $device" || \
            echo "WARNING: Failed to enable $device" >&2
    else
        echo "ACPI wakeup already active: $device ($status)"
    fi
done

# 接続済みUSBデバイスの個別wakeup有効化
if [ -d /sys/bus/usb/devices ]; then
    for wakeup_file in /sys/bus/usb/devices/*/power/wakeup; do
        [ -f "$wakeup_file" ] || continue
        current=$(cat "$wakeup_file" 2>/dev/null)
        if [ "$current" = "disabled" ]; then
            echo "enabled" > "$wakeup_file" 2>/dev/null && \
                echo "Enabled: $wakeup_file" || true
        fi
    done
fi

echo "USB wakeup configuration complete."
