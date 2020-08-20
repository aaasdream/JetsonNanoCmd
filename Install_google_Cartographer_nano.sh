#!/bin/bash
#PC版本與嵌入式裝置是不相同的 ，PC版本如下網址
#  https://google-cartographer-ros.readthedocs.io/en/latest/compilation.html#building-installation
# 嵌入式版本 如下網址
#https://google-cartographer-ros-for-turtlebots.readthedocs.io/en/latest/
# 
# 本文件使用嵌入式版本指令安裝，給jetson nano使用

# Install wstool and rosdep.
sudo apt-get update
sudo apt-get install -y python-wstool python-rosdep ninja-build

# Create a new workspace in 'catkin_ws'.
mkdir catkin_googlews
cd catkin_googlews
wstool init src

# Merge the cartographer_turtlebot.rosinstall file and fetch code for dependencies.
wstool merge -t src https://raw.githubusercontent.com/googlecartographer/cartographer_turtlebot/master/cartographer_turtlebot.rosinstall
wstool update -t src

# Install deb dependencies.
# The command 'sudo rosdep init' will print an error if you have already
# executed it since installing ROS. This error can be ignored.
sudo rosdep init
rosdep update
rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y

# Build and install.
catkin_make_isolated --install --use-ninja
source install_isolated/setup.bash
echo "source ~/catkin_googlews/install_isolated/setup.bash" >> ~/.bashrc



echo "Download and run demo."
wget -P ~/Downloads https://storage.googleapis.com/cartographer-public-data/bags/backpack_2d/cartographer_paper_deutsches_museum.bag
roslaunch cartographer_ros demo_backpack_2d.launch bag_filename:=${HOME}/Downloads/cartographer_paper_deutsches_museum.bag


