#!/usr/bin/sh

NVIM_BEGINNER=~/.config
export NVIM_BEGINNER

rm -rf $NVIM_BEGINNER

mkdir -p $NVIM_BEGINNER/share
mkdir -p $NVIM_BEGINNER/nvim

stow --restow --target=$NVIM_BEGINNER/nvim .

alias nvb='XDG_DATA_HOME=$NVIM_BEGINNER/share XDG_CACHE_HOME=$NVIM_BEGINNER XDG_CONFIG_HOME=$NVIM_BEGINNER nvim'
