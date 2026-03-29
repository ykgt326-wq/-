#!/bin/bash
# USBコントローラのACPI wakeupを有効化するスクリプト
# /proc/acpi/wakeup の XHC/EHC エントリを有効化する

set -euo pipefail

WAKEUP_FILE="/proc/acpi/wakeup"

if [ ! -f "$WAKEUP_FILE" ]; then
    echo "WARNING: $WAKEUP_FILE not found" >&2
    exit 0
fi

# 有効化対象のUSBコントローラ名
USB_DEVICES=(XHC XHC0 XHC1 XHC2 XHC3 EHC1 EHC2 USB0 USB1 USB2 USB3 USB4 USBC)

for device in "${USB_DEVICES[@]}"; do
    if grep -q "^${device}[[:space:]]" "$WAKEUP_FILE" 2>/dev/null; then
        status=$(grep "^${device}[[:space:]]" "$WAKEUP_FILE" | awk '{print $3}')
        if [ "$status" = "*disabled" ]; then
            echo "$device" > "$WAKEUP_FILE"
            echo "Enabled wakeup for $device"
        else
            echo "Wakeup already enabled for $device ($status)"
        fi
    fi
done

# 接続済みUSBデバイスの個別wakeup有効化
if [ -d /sys/bus/usb/devices ]; then
    for dev in /sys/bus/usb/devices/*/power/wakeup; do
        if [ -f "$dev" ]; then
            echo enabled > "$dev" 2>/dev/null && echo "Enabled: $dev" || true
        fi
    done
fi

echo "USB wakeup configuration complete."
