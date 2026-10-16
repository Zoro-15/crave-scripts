#!/usr/bin/env bash
set -e

# --- Memory tuning for Soong (Go) ---
export GOMEMLIMIT=10GiB
export GOGC=40

# Sync AxionAOSP
rm -rf .repo/local_manifests
repo init -u https://github.com/AxionAOSP/android.git -b lineage-23.2 --git-lfs --depth 1
if [ -f /opt/crave/resync.sh ]; then
    /opt/crave/resync.sh
else
    repo sync -c -j8 --force-sync --no-clone-bundle --no-tags
fi

# Pull LFS
repo forall -c 'git lfs pull'

# Clone device trees and dependencies
rm -rf device/motorola/cancunf \
       device/motorola/cancunf-kernel \
       vendor/motorola/cancunf \
       vendor/motorola/cancunf-motcamera \
       packages/apps/DisplayFeatures \
       hardware/mediatek \
       device/mediatek/sepolicy_vndr

git clone -b sixteen-qpr2 --depth 1 https://github.com/sarthakroy2002/device_motorola_cancunf device/motorola/cancunf
git clone -b sixteen-qpr2 --depth 1 https://github.com/sarthakroy2002/device_motorola_cancunf-kernel device/motorola/cancunf-kernel
git clone -b sixteen-qpr2 --depth 1 https://github.com/sarthakroy2002/vendor_motorola_cancunf vendor/motorola/cancunf
git clone -b sixteen --depth 1 https://github.com/yaap/vendor_motorola_cancunf-motcamera vendor/motorola/cancunf-motcamera
git clone -b master --depth 1 https://github.com/cyberknight777/android_packages_apps_DisplayFeatures packages/apps/DisplayFeatures
git clone -b sixteen --depth 1 https://github.com/yaap/hardware_mediatek hardware/mediatek
git clone -b sixteen --depth 1 https://github.com/yaap/device_mediatek_sepolicy_vndr device/mediatek/sepolicy_vndr

# Rename and configure makefiles
[ -f device/motorola/cancunf/custom_cancunf.mk ] && mv device/motorola/cancunf/custom_cancunf.mk device/motorola/cancunf/lineage_cancunf.mk
sed -i 's/custom/lineage/g' device/motorola/cancunf/AndroidProducts.mk
sed -i 's/custom/lineage/g' device/motorola/cancunf/lineage_cancunf.mk

cat << 'EOF' >> device/motorola/cancunf/lineage_cancunf.mk

# AxionOS Properties
TARGET_DISABLE_EPPE := true
AXION_MAINTAINER := Zoro-15
AXION_PROCESSOR := Dimensity_7020
AXION_CAMERA_REAR_INFO := 50,2
AXION_CAMERA_FRONT_INFO := 16
EOF

# Cherry-pick HardwareManager fix
git -C device/motorola/cancunf remote add 2by2 https://github.com/2by2-Project-Devices/android_device_motorola_cancunf.git 2>/dev/null || true
git -C device/motorola/cancunf fetch 2by2
if ! git -C device/motorola/cancunf cherry-pick 42403f68003b2ed3de8d508042c4d7696b2f4f60; then
    TOUCH_KEY="device/motorola/cancunf/app/MotoActions/src/org/lineageos/settings/device/TouchKeyHandler.java"
    sed -i '/<<<<<<< HEAD/,/=======/d' "$TOUCH_KEY" 2>/dev/null || true
    sed -i '/>>>>>>>/d' "$TOUCH_KEY" 2>/dev/null || true
    grep -q "import lineageos.providers.LineageSettings;" "$TOUCH_KEY" || sed -i '/import com.android.internal.os.DeviceKeyHandler;/a import lineageos.providers.LineageSettings;' "$TOUCH_KEY"
    grep -q "GESTURE_WAKELOCK_DURATION" "$TOUCH_KEY" || sed -i '/private static final int GESTURE_REQUEST = 0;/a \    private static final int GESTURE_WAKELOCK_DURATION = 3000;' "$TOUCH_KEY"
    sed -i 's/android\.content\.Intent\.ACTION_SCREEN_CAMERA_GESTURE/lineageos\.content\.Intent\.ACTION_SCREEN_CAMERA_GESTURE/g' "$TOUCH_KEY"
    sed -i 's/Settings\.System\.TOUCHSCREEN_GESTURE_HAPTIC_FEEDBACK/LineageSettings\.System\.TOUCHSCREEN_GESTURE_HAPTIC_FEEDBACK/g' "$TOUCH_KEY"
    git -C device/motorola/cancunf add "$TOUCH_KEY"
    git -C device/motorola/cancunf -c core.editor=true cherry-pick --continue --no-edit || true
fi

# Cherry-pick MTK boot jars whitelist
git -C build/soong remote add yaap https://github.com/yaap/build_soong.git 2>/dev/null || true
git -C build/soong fetch yaap sixteen
if ! git -C build/soong cherry-pick yaap/sixteen; then
    ALLOWED_LIST="build/soong/scripts/check_boot_jars/package_allowed_list.txt"
    sed -i '/<<<<<<< HEAD/d' "$ALLOWED_LIST"
    sed -i '/=======/d' "$ALLOWED_LIST"
    sed -i '/>>>>>>>/d' "$ALLOWED_LIST"
    grep -q "com\\\\.mediatek\\\\..*" "$ALLOWED_LIST" || printf "\n# MTK adds\ncom\\.mediatek\\..*\n" >> "$ALLOWED_LIST"
    git -C build/soong add "$ALLOWED_LIST"
    git -C build/soong -c core.editor=true cherry-pick --continue --no-edit || true
fi

# Signing keys
rm -rf /tmp/lineage-scripts
git clone -b main https://github.com/LineageOS/scripts.git /tmp/lineage-scripts
mkdir -p vendor/lineage-priv
rm -rf vendor/lineage-priv/keys
mv /tmp/lineage-scripts/lineage-priv-template vendor/lineage-priv/keys
rm -rf /tmp/lineage-scripts
(cd vendor/lineage-priv/keys && ./keys.sh)

# Build
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
ccache -M 50G 2>/dev/null || true

source build/envsetup.sh
lunch lineage_cancunf-bp4a-user
m bacon -j8

ROM_ZIP=$(find out/target/product/cancunf -maxdepth 1 -name "*.zip" ! -name "*ota*" ! -name "*target_files*" 2>/dev/null | head -n 1)
[ -z "$ROM_ZIP" ] && ROM_ZIP=$(ls out/target/product/cancunf/*.zip 2>/dev/null | head -n 1)

echo "========================================================"
echo "Uploading artifact to temp.sh..."
TEMP_URL=$(curl --fail --silent --show-error --max-time 1800 \
    -F "file=@${ROM_ZIP}" https://temp.sh/upload 2>&1) || {
    echo "ERROR: temp.sh upload failed"
    echo "$TEMP_URL"
    exit 1
}
echo "$TEMP_URL"
echo "$TEMP_URL" > "${ROM_ZIP}.temp.sh.url"
echo "========================================================"
echo "=== AxionOS Build Finished Successfully! ==="
