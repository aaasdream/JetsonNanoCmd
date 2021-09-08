#!/bin/bash
# 這是自動安裝ROS Ubuntu 18 ，ROS Melodic
sudo apt install -y curl
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | sudo apt-key add -
sudo apt update
sudo apt install -y ros-melodic-desktop-full
sudo apt install -y python3-pip python3-all-dev python3-rospkg
sudo apt install -y ros-melodic-desktop-full --fix-missing



#建立工作資料夾
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src
catkin_init_workspace
cd ~/catkin_ws/
catkin_make
 
source devel/setup.bash
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
sudo apt-get  -y install ros-$ROS_DISTRO-usb-cam

#echo "Finish. test roscore"
roscore


