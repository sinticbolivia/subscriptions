#!/bin/bash
ICU_PATH=/usr/local/Cellar/icu4c/74.2/lib/pkgconfig
LIBPQ_PATH=/usr/local/Cellar/libpq/16.2_1/lib/pkgconfig
export PKG_CONFIG_PATH=$LIBPQ_PATH:$ICU_PATH
meson build
