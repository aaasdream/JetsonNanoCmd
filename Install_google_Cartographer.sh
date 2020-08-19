#!/bin/bash
#https://google-cartographer-ros.readthedocs.io/en/latest/compilation.html#building-installation
#看這個網址安裝即可
sudo apt-get update
sudo apt-get install -y python-wstool python-rosdep ninja-build
sudo apt-get install ros-indigo-pcl-conversions
cd ~
mkdir catkin_googlews
cd catkin_googlews
wstool init src
wstool merge -t src https://raw.githubusercontent.com/googlecartographer/cartographer_ros/master/cartographer_ros.rosinstall
wstool update -t src

src/cartographer/scripts/install_proto3.sh
sudo rosdep init
rosdep update
rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y
catkin_make_isolated --install --use-ninja
echo "source ~/catkin_googlews/install_isolated/setup.bash" >> ~/.bashrc


