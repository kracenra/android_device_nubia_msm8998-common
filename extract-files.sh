#!/bin/bash
#
# Copyright (C) 2017 The MoKee Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

# Load extractutils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

MK_ROOT="${MY_DIR}/../../.."

HELPER="${MK_ROOT}/vendor/mokee/build/tools/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true
SECTION=
KANG=

while [ "$1" != "" ]; do
    case "$1" in
        -n | --no-cleanup )     CLEAN_VENDOR=false
                                ;;
        -k | --kang)            KANG="--kang"
                                ;;
        -s | --section )        shift
                                SECTION="$1"
                                CLEAN_VENDOR=false
                                ;;
        * )                     SRC="$1"
                                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC=adb
fi

function blob_fixup() {
    case "${1}" in

    vendor/lib/libarcsoft_picauto.so)
         patchelf --remove-needed libandroid.so "${2}"
         ;;

    vendor/lib/libmmcamera_ppeiscore.so | vendor/lib/libmmcamera_bokeh.so| vendor/lib/hw/camera.msm8998.so | vendor/lib/libnubia_effect.so | vendor/lib64/libnubia_effect.so)
        sed -i "s|libgui.so|libfui.so|g" "${2}"
        ;;

    vendor/lib/libNubiaImageAlgorithm.so)
        patchelf --add-needed libNubiaImageAlgorithmShim.so "${2}"
        ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE_COMMON}" "${VENDOR}" "${MK_ROOT}" true "${CLEAN_VENDOR}"

extract "${MY_DIR}"/proprietary-files-qc.txt "${SRC}" "${SECTION}"
extract "${MY_DIR}"/proprietary-files.txt "${SRC}" "${SECTION}"

if [ -s "${MY_DIR}"/../${DEVICE}/proprietary-files.txt ]; then
    # Reinitialize the helper for device
    setup_vendor "${DEVICE}" "${VENDOR}" "${MK_ROOT}" false "${CLEAN_VENDOR}"

    extract "${MY_DIR}"/../${DEVICE}/proprietary-files.txt "${SRC}" "${SECTION}"
fi

"${MY_DIR}"/setup-makefiles.sh
