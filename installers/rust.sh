#!/usr/bin/env bash
if ! command -v cargo >/dev/null; then
  curl https://sh.rustup.rs -sSf | sh
fi

