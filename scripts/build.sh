#!/bin/bash

set -ex

TAG_LIBVA=2.12.0
TAG_LIBVA_UTILS=2.12.0
TAG_GMMLIB=intel-gmmlib-21.2.1
TAG_MEDIA_DRIVER=intel-media-21.2.3
TAG_MEDIASDK=intel-mediasdk-21.2.0
TAG_OPENH264=v2.1.1
TAG_FFMPEG=n4.4
TAG_OPENCV=4.5.4

mkdir -p install
DST=$(cd install ; pwd)

export PKG_CONFIG_PATH=${DST}/lib/pkgconfig
export LIBRARY_PATH=${DST}/lib
export CPATH=${DST}/include

# VID=/scripts/Sintel.2010.1080p.mkv
VID=/scripts/test_PVGeM40dABA_avc1.640028_1920x804.mp4

build_openh264()
{
    # ===== OpenH264
    [ ! -d openh264 ] && git clone --depth=1 https://github.com/cisco/openh264 --branch ${TAG_OPENH264}
    pushd openh264
    make clean
    make -j 13 ENABLE64BIT=Yes PREFIX=${DST} install
    popd
}

build_libva()
{
    # ===== LIBVA
    [ ! -d libva ] && git clone --depth=1 https://github.com/intel/libva --branch ${TAG_LIBVA}
    pushd libva
    ./autogen.sh --prefix=${DST}
    make -j8
    make install
    popd

    # ===== LIBVA-utils
    [ ! -d libva-utils ] && git clone --depth=1 https://github.com/intel/libva-utils --branch ${TAG_LIBVA_UTILS}
    pushd libva-utils
    ./autogen.sh --prefix=${DST}
    make -j8
    make install
    popd
}

build_msdk()
{
    # ===== MediaSDK
    [ ! -d MediaSDK ] && git clone --depth=1 https://github.com/Intel-Media-SDK/MediaSDK.git --branch ${TAG_MEDIASDK}
    mkdir -p MediaSDK/build
    pushd MediaSDK/build
    rm -rf *
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=${DST} ..
    ninja install
    popd
}

build_media_driver()
{
    # ===== GMMLIB
    [ ! -d gmmlib ] && git clone --depth=1 https://github.com/intel/gmmlib.git --branch ${TAG_GMMLIB}
    mkdir -p gmmlib/build
    pushd gmmlib/build
    rm -rf *
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=${DST} -DRUN_TEST_SUITE=OFF ..
    ninja install
    popd

    # ===== iHD
    [ ! -d media-driver ] && git clone --depth=1 https://github.com/intel/media-driver.git --branch ${TAG_MEDIA_DRIVER}
    mkdir -p media-driver/build
    pushd media-driver/build
    rm -rf *
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=${DST} -DMEDIA_RUN_TEST_SUITE=OFF ..
    ninja install
    popd
}

build_ffmpeg()
{
    # ===== FFmpeg
    [ ! -d ffmpeg ] && git clone --depth=1 https://git.ffmpeg.org/ffmpeg.git --branch ${TAG_FFMPEG}
    pushd ffmpeg
    ./configure \
        --enable-libmfx \
        --disable-static \
        --enable-shared \
        --enable-pic \
        --enable-libopenh264 \
        --disable-gpl \
        --disable-nonfree \
        --prefix=${DST}
    make -j 13
    make install
    popd
    # --enable-gpl \
    # --arch=native \
}

build_opencv()
{
    # ===== OpenCV
    [ ! -d opencv ] && git clone --depth=1 https://github.com/opencv/opencv --branch ${TAG_OPENCV}
    [ ! -d opencv ] && git clone --depth=1 https://github.com/opencv/opencv_extra --branch ${TAG_OPENCV}
    mkdir -p opencv/build
    pushd opencv/build && rm -rf *
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=${DST} ..
    ninja opencv_python3
    popd
}

test_ffmpeg()
{
    # ffprobe ${VID}
    echo "============================================="
    time ffmpeg -benchmark -i ${VID} -f null -
    echo "============================================="
    time ffmpeg -benchmark -hwaccel qsv -c:v h264_qsv -i ${VID} -f null -
    echo "============================================="
    time ffmpeg -benchmark -c:v libopenh264 -i ${VID} -f null -
    echo "============================================="
}

test_opencv()
{
    time python3 /scripts/test.py ${VID}
    time OPENCV_FFMPEG_CAPTURE_OPTIONS="hwaccel;qsv|video_codec;h264_qsv|vsync;0" python3 /scripts/test.py ${VID}
    time OPENCV_FFMPEG_CAPTURE_OPTIONS="video_codec;libopenh264" python3 /scripts/test.py ${VID}
}

build_openh264
build_libva
build_media_driver
build_msdk
build_ffmpeg
build_opencv
test_ffmpeg
test_opencv
