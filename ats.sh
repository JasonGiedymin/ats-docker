#!/bin/bash

set -e

autoreconf -if
./configure --prefix=$PREFIX
make
sudo make install
