#!/bin/bash

vlc_plugins_dir=~/.local/share/vlc/lua/
"Creating directory for VLC plugins"
mkdir -p  $vlc_plugins_dir/playlist
mkdir -p  $vlc_plugins_dir/extensions
"Downloading youtube-playlist plugin"
curl https://raw.githubusercontent.com/videolan/vlc/master/share/lua/playlist/youtube.lua >> $vlc_plugins_dir/playlist/youtube.lua
"Copying the youtube channel feed plugin"
cp ./vlc-lua/*.lua $vlc_plugins_dir/extensions
"Latest plugin can be found here: https://addons.videolan.org/p/1412578/"

