#!/bin/bash

if [ ! -d "pack/bundle" ]; then
  mkdir -p pack/bundle/{start,opt}
  mkdir -p pack/my/{start,opt}
  mkdir -p pack/themes/opt
fi

if [ ! -d "pack/bundle/opt/vim-shortcut" ]; then
  git clone https://github.com/sunaku/vim-shortcut.git pack/bundle/opt/vim-shortcut
fi

if [ ! -d "pack/bundle/start/vim-mucomplete" ]; then
  git clone https://github.com/lifepillar/vim-mucomplete.git pack/bundle/start/vim-mucomplete
fi

echo "DONE"
