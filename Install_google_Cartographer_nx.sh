#!/bin/bash
#這是安裝Nvidia Jetson naon and nx版本的Cartographer 
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
sudo apt-get install -y python3-wstool python3-rosdep ninja-build stow
sudo apt-get install -y stow
sudo apt-get install -y ninja-build
sudo apt-get install -y liblua5.2-dev

cd ~
mkdir catkin_google_ws
cd catkin_google_ws
#install ceres-solver
wget http://ceres-solver.org/ceres-solver-2.0.0.tar.gz
# CMake
sudo apt-get install -y cmake
# google-glog + gflags
sudo apt-get install -y libgoogle-glog-dev libgflags-dev
# BLAS & LAPACK
sudo apt-get install -y libatlas-base-dev
# Eigen3
sudo apt-get install -y libeigen3-dev
# SuiteSparse and CXSparse (optional)
sudo apt-get install -y libsuitesparse-dev

tar zxf ceres-solver-2.0.0.tar.gz
mkdir ceres-bin
cd ceres-bin
cmake ../ceres-solver-2.0.0
make -j3
sudo make install



cd ~/catkin_google_ws


wstool init src
wstool merge -t src https://raw.githubusercontent.com/cartographer-project/cartographer_ros/master/cartographer_ros.rosinstall
wstool update -t src

sudo rosdep init
rosdep update
rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y

src/cartographer/scripts/install_abseil.sh
catkin_make_isolated --install --use-ninja


source install_isolated/setup.bash
echo "source ~/catkin_google_ws/install_isolated/setup.bash" >> ~/.bashrc

echo "Download and run demo."
wget -P ~/Downloads https://storage.googleapis.com/cartographer-public-data/bags/backpack_2d/cartographer_paper_deutsches_museum.bag
roslaunch cartographer_ros demo_backpack_2d.launch bag_filename:=${HOME}/Downloads/cartographer_paper_deutsches_museum.bag


