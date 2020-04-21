#!/bin/bash
# shellcheck disable=SC1090
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSOS_PATH}/scripts
BOARD_DIR=${2}

. "${BR2_EXTERNAL_HASSOS_PATH}/meta"
. "${BOARD_DIR}/meta"

. "${SCRIPT_DIR}/rootfs-layer.sh"
. "${SCRIPT_DIR}/name.sh"
. "${SCRIPT_DIR}/rauc.sh"


# HassOS tasks
fix_rootfs
install_tini_docker
install_hassos_cli

# Write os-release
# shellcheck disable=SC2153
(
    echo "NAME=${HASSOS_NAME}"
    echo "VERSION=\"${VERSION_MAJOR}.${VERSION_BUILD} (${BOARD_NAME})\""
    echo "ID=${HASSOS_ID}"
    echo "VERSION_ID=${VERSION_MAJOR}.${VERSION_BUILD}"
    echo "PRETTY_NAME=\"${HASSOS_NAME} ${VERSION_MAJOR}.${VERSION_BUILD}\""
    echo "CPE_NAME=cpe:2.3:o:home_assistant:${HASSOS_ID}:${VERSION_MAJOR}.${VERSION_BUILD}:*:${DEPLOYMENT}:*:*:*:${BOARD_ID}:*"
    echo "HOME_URL=https://hass.io/"
    echo "VARIANT=\"${HASSOS_NAME} ${BOARD_NAME}\""
    echo "VARIANT_ID=${BOARD_ID}"
    echo "SUPERVISOR_MACHINE=${SUPERVISOR_MACHINE}"
    echo "SUPERVISOR_ARCH=${SUPERVISOR_ARCH}"
) > "${TARGET_DIR}/usr/lib/os-release"

# Write machine-info
(
    echo "CHASSIS=${CHASSIS}"
    echo "DEPLOYMENT=${DEPLOYMENT}"
) > "${TARGET_DIR}/etc/machine-info"


# Setup RAUC
write_rauc_config
install_rauc_certs
install_bootloader_config
