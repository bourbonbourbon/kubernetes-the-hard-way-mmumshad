#!/bin/bash
set -e

GUEST_ADDITION_VERSION=7.2.14
GUEST_ADDITION_ISO="VBoxGuestAdditions_${GUEST_ADDITION_VERSION}.iso"
GUEST_ADDITION_MOUNT=/media/VBoxGuestAdditions

apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install "linux-headers-$(uname -r)" build-essential dkms wget

wget "https://download.virtualbox.org/virtualbox/${GUEST_ADDITION_VERSION}/${GUEST_ADDITION_ISO}"
mkdir -p "${GUEST_ADDITION_MOUNT}"
mount -o loop,ro "${GUEST_ADDITION_ISO}" "${GUEST_ADDITION_MOUNT}"
sh "${GUEST_ADDITION_MOUNT}/VBoxLinuxAdditions.run"
rm "${GUEST_ADDITION_ISO}"
umount "${GUEST_ADDITION_MOUNT}"
rmdir "${GUEST_ADDITION_MOUNT}"
