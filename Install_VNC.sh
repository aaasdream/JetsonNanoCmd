#!/bin/bash
# 啟動VNC的指令紀錄
sudo apt update
sudo apt install vino
sudo ln -s ../vino-server.service     /usr/lib/systemd/user/graphical-session.target.wants
gsettings set org.gnome.Vino prompt-enabled false
gsettings set org.gnome.Vino require-encryption false
gsettings set org.gnome.Vino authentication-methods "['vnc']"
gsettings set org.gnome.Vino vnc-password $(echo -n '請修改密碼'|base64)
sudo reboot
