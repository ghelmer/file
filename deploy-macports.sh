#!/bin/sh

DEPLOY_HOST=capella.palisadesys.com
DEPLOY_BASE_DIR=/home/projects/OSXBuild/Artifacts/MacPorts

read -p "Enter deployment version: " VER
read -p "Enter deployment branch: " BRANCH

if [ -z "$VER" ]; then
    echo "Invalid deployment version."
    exit 1
fi
if [ -z "$BRANCH" ]; then
    echo "Invalid deployment branch."
    exit 1
fi

exists=`ssh ${DEPLOY_HOST} "if [ -d ${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER} ]; then echo yes; else echo no; fi"`
if [ "$exists" != "no" ]; then
    echo "Error: ${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER} already exists"
    exit 1
fi
exists=`ssh ${DEPLOY_HOST} "if [ -d ${DEPLOY_BASE_DIR}/${BRANCH}/libmagic/${VER} ]; then echo yes; else echo no; fi"`
if [ "$exists" != "no" ]; then
    echo "Error: ${DEPLOY_BASE_DIR}/${BRANCH}/libmagic/${VER} already exists"
    exit 1
fi

ssh ${DEPLOY_HOST} mkdir -p ${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER}/bin
ssh ${DEPLOY_HOST} mkdir -p ${DEPLOY_BASE_DIR}/${BRANCH}/libmagic/${VER}/include
ssh ${DEPLOY_HOST} mkdir -p ${DEPLOY_BASE_DIR}/${BRANCH}/libmagic/${VER}/lib
ssh ${DEPLOY_HOST} mkdir -p ${DEPLOY_BASE_DIR}/${BRANCH}/libmagic/${VER}/share/misc
scp src/.libs/file ${DEPLOY_HOST}:${DEPLOY_BASE_DIR}/${BRANCH}/file/${VER}/bin
scp src/magic.h ${DEPLOY_HOST}:${DEPLOY_BASE_DIR}/${BRANCH}/libmagic/${VER}/include
scp src/.libs/libmagic.1.dylib ${DEPLOY_HOST}:${DEPLOY_BASE_DIR}/${BRANCH}/libmagic/${VER}/lib
ssh ${DEPLOY_HOST} "cd ${DEPLOY_BASE_DIR}/${BRANCH}/libmagic/${VER}/lib && ln -s libmagic.1.dylib libmagic.dylib"
scp magic/magic.mgc ${DEPLOY_HOST}:${DEPLOY_BASE_DIR}/${BRANCH}/libmagic/${VER}/share/misc
