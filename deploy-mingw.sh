#!/bin/sh
#
# Build:
#   ./configure --enable-static --disable-shared --no-recursion --disable-zlib
#   make

DEPLOY_HOST=capella.palisadesys.com
DEPLOY_BASE_DIR=/home/projects/WinBuild/Artifacts/MinGW64

read -p "Enter deployment version: " VER
read -p "Enter deployment branch: " BRANCH
ARCH=`gcc -dumpmachine | sed 's/-.*//'`

if [ -z "$VER" ]; then
    echo "Invalid deployment version."
    exit 1
fi
if [ -z "$BRANCH" ]; then
    echo "Invalid deployment branch."
    exit 1
fi
if [ -z "$ARCH" ]; then
    echo "Invalid deployment architecture."
    exit 1
fi

exists=`ssh ${DEPLOY_HOST} "if [ -d ${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER}/${ARCH} ]; then echo yes; else echo no; fi"`
if [ "$exists" != "no" ]; then
    echo "Error: ${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER}/${ARCH} already exists"
    exit 1
fi

ssh ${DEPLOY_HOST} mkdir -p ${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER}/${ARCH}/bin
ssh ${DEPLOY_HOST} mkdir -p ${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER}/${ARCH}/include
ssh ${DEPLOY_HOST} mkdir -p ${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER}/${ARCH}/lib
ssh ${DEPLOY_HOST} mkdir -p ${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER}/${ARCH}/share/misc
scp src/file.exe ${DEPLOY_HOST}:${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER}/${ARCH}/bin
scp src/magic.h ${DEPLOY_HOST}:${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER}/${ARCH}/include
scp src/.libs/libmagic.a ${DEPLOY_HOST}:${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER}/${ARCH}/lib
scp magic/magic.mgc ${DEPLOY_HOST}:${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER}/${ARCH}/share/misc
