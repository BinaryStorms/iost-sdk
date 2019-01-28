#!/bin/bash

if [ ! -d "/app/secp256k1" ]; then
  git clone https://github.com/bitcoin-core/secp256k1
  cd /app/secp256k1 && ./autogen.sh && ./configure --enable-module-recovery --enable-experimental --enable-module-ecdh --enable-module-schnorr && make && ./tests && sudo make install
fi
