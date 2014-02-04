#!/bin/bash

cd $(cd $(dirname $0);pwd)/tools/src/
make -f make/gcc.mak
