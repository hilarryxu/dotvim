#!/bin/bash

if [ ! -d "pack/bundle" ]; then
  mkdir -p pack/bundle/{start,opt}
  mkdir -p pack/my/{start,opt}
  mkdir -p pack/themes/opt
fi

function Plug() {
  local repo=$1
  local name=`echo $repo | cut -f 2 -d /`
  local path=pack/bundle/start/${name}
  if [ ! -d "$path" ]; then
    git clone https://github.com/$repo.git $path
  fi
}

Plug hilarryxu/xcc.vim
Plug hilarryxu/tag-preview.vim
Plug hilarryxu/LeaderF-funky

Plug ctrlpvim/ctrlp.vim
Plug Yggdroot/LeaderF
Plug lifepillar/vim-mucomplete
Plug SirVer/ultisnips
Plug honza/vim-snippets
Plug t9md/vim-choosewin
Plug skywind3000/asyncrun.vim

Plug tpope/vim-commentary
Plug tpope/vim-surround
Plug tpope/vim-repeat
Plug tpope/vim-scriptease
Plug tpope/tpope-vim-abolish
Plug tpope/vim-unimpaired
Plug tpope/vim-eunuch
Plug tpope/vim-projectionist
Plug tpope/vim-fugitive

Plug junegunn/vim-easy-align
Plug junegunn/gv.vim
Plug junegunn/vim-slash
Plug junegunn/vim-peekaboo
Plug junegunn/goyo.vim
Plug junegunn/limelight.vim

Plug justinmk/vim-dirvish
Plug justinmk/vim-sneak

echo "DONE"
