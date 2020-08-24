#!/bin/bash
#這是安裝Nvidia Jetson nano版本的Cartographer
# ros : melodic
# 安裝路徑 ~/catkin_google_ws


#jetson nano 與PC版安裝差異
#   增加安裝ros-melodic-pcl-conversions   ros-melodic-tf2-eigen
# 注意事項 請在安裝openvslam之前安裝，
# 執行即可 不需要任何參數不需要權限，安裝過程會詢問最高權限密碼

# 官方安裝教學網址
#  https://google-cartographer-ros.readthedocs.io/en/latest/compilation.html#building-installation



sudo apt-get update
sudo apt-get install -y ros-melodic-pcl-conversions ros-melodic-tf2-eigen
sudo apt-get install -y python-wstool python-rosdep ninja-build
cd ~
mkdir catkin_google_ws
cd catkin_google_ws
wstool init src
wstool merge -t src https://raw.githubusercontent.com/cartographer-project/cartographer_ros/master/cartographer_ros.rosinstall
wstool update -t src

src/cartographer/scripts/install_proto3.sh
sudo rosdep init
rosdep update
rosdep install --from-paths src --ignore-src --rosdistr==${ROS_DISTRO} -y -i -r
catkin_make_isolated --install --use-ninja

source install_isolated/setup.bash
echo "source ~/catkin_google_ws/install_isolated/setup.bash" >> ~/.bashrc

echo "Download and run demo."
wget -P ~/Downloads https://storage.googleapis.com/cartographer-public-data/bags/backpack_2d/cartographer_paper_deutsches_museum.bag
roslaunch cartographer_ros demo_backpack_2d.launch bag_filename:=${HOME}/Downloads/cartographer_paper_deutsches_museum.bag



