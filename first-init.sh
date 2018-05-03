#!/bin/bash

git checkout hexo
git submodule update --init --recursive
npm install -g hexo-cli
# avoid fatal error: sass/context.h
LIBSASS_EXT="no" npm install
