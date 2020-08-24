#!/bin/bash
# 這是jetson Nano 安裝openvslam 因為nano已經是ubuntu 18 且opencv已經預先安裝
# 這是自動安裝openvslam 安裝在~/openvslam_pkg/openvslam/build 下面
# glew-2.1.0
# eigen-3.3.7
# g2o
# Pangolin
# openvslam


sudo apt-get update
sudo apt-get install -y build-essential pkg-config cmake git wget curl unzip
sudo apt-get install -y libatlas-base-dev libsuitesparse-dev
sudo apt-get install -y libgtk-3-dev
sudo apt-get install -y ffmpeg
sudo apt-get install -y libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavresample-dev
sudo apt-get install -y libgoogle-glog-dev libgflags-dev
sudo apt-get install -y libopenblas-dev
sudo apt-get install -y --no-install-recommends libboost1.65-all-dev 
sudo apt-get install -y libx11-dev 
sudo apt-get install -y libgl1-mesa-dev 
sudo apt-get install -y freeglut3-dev 
sudo apt-get install -y doxygen 

mkdir ~/openvslam_pkg
cd ~/openvslam_pkg
wget https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.tgz
tar -xzvf glew-2.1.0.tgz 
cd glew-2.1.0
make -j2
sudo make install 
sudo ln -s /usr/lib64/libGLEW.so.2.1 /usr/lib/libGLEW.so.2.1


cd ~/openvslam_pkg
wget https://github.com/eigenteam/eigen-git-mirror/archive/3.3.7.tar.gz 
tar -xzvf 3.3.7.tar.gz 
mv eigen-git-mirror-3.3.7/ eigen-3.3.7/ 
cd eigen-3.3.7/ 
mkdir build && cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    ..
make -j2
sudo make install 

cd ~/openvslam_pkg
git clone https://github.com/RainerKuemmerle/g2o.git
cd g2o
mkdir build && cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_CXX_FLAGS=-std=c++11 \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_UNITTESTS=OFF \
    -DBUILD_WITH_MARCH_NATIVE=ON \
    -DG2O_USE_CHOLMOD=ON \
    -DG2O_USE_CSPARSE=ON \
    -DG2O_USE_OPENGL=OFF \
    -DG2O_USE_OPENMP=ON \
    ..
make -j2
sudo make install 


cd ~/openvslam_pkg
git clone https://github.com/stevenlovegrove/Pangolin.git
cd Pangolin
mkdir build && cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    ..
make
sudo make install 

cd ~/openvslam_pkg
git clone https://github.com/shinsumicco/DBoW2.git
cd DBoW2
mkdir build && cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    ..
make -j2
sudo make install 
sudo ldconfig -v

cd ~/openvslam_pkg
git clone https://github.com/jbeder/yaml-cpp
cd yaml-cpp
mkdir build && cd build
cmake \
​    -DYAML_BUILD_SHARED_LIBS=ON \
​    -DCMAKE_BUILD_TYPE=Release \
​    -DCMAKE_INSTALL_PREFIX=/usr/local \
​    ..
make -j2
sudo make install 

cd ~/openvslam_pkg
git clone https://github.com/xdspacelab/openvslam
cd openvslam
git submodule init
git submodule update
mkdir build && cd build
cmake \
    -DBUILD_WITH_MARCH_NATIVE=ON \
    -DUSE_PANGOLIN_VIEWER=ON \
    -DUSE_SOCKET_PUBLISHER=OFF \
    -DUSE_STACK_TRACE_LOGGER=ON \
    -DBOW_FRAMEWORK=DBoW2 \
    -DBUILD_TESTS=ON \
    ..
make -j2



echo "ROS Package"
sudo apt install -y ros-${ROS_DISTRO}-image-transport

cd ~/openvslam_pkg/openvslam/ros
git clone --branch ${ROS_DISTRO} --depth 1 https://github.com/ros-perception/vision_opencv.git
cp -r vision_opencv/cv_bridge src/
rm -rf vision_opencv

#ros PangolinViewer config
catkin_make \
    -DBUILD_WITH_MARCH_NATIVE=ON \
    -DUSE_PANGOLIN_VIEWER=ON \
    -DUSE_SOCKET_PUBLISHER=OFF \
    -DUSE_STACK_TRACE_LOGGER=ON \
    -DBOW_FRAMEWORK=DBoW2

echo "source ~/openvslam_pkg/openvslam/ros/devel/setup.bash" >> ~/.bashrc
source ~/openvslam_pkg/openvslam/ros/devel/setup.bash


echo "Download and run Demo"
cd ~/openvslam_pkg/openvslam/build
# download an ORB vocabulary from Google Drive
FILE_ID="1wUPb328th8bUqhOk-i8xllt5mgRW4n84"
curl -sc /tmp/cookie "https://drive.google.com/uc?export=download&id=${FILE_ID}" > /dev/null
CODE="$(awk '/_warning_/ {print $NF}' /tmp/cookie)"
curl -sLb /tmp/cookie "https://drive.google.com/uc?export=download&confirm=${CODE}&id=${FILE_ID}" -o orb_vocab.zip
unzip orb_vocab.zip

# download a sample dataset from Google Drive
FILE_ID="1d8kADKWBptEqTF7jEVhKatBEdN7g0ikY"
curl -sc /tmp/cookie "https://drive.google.com/uc?export=download&id=${FILE_ID}" > /dev/null
CODE="$(awk '/_warning_/ {print $NF}' /tmp/cookie)"
curl -sLb /tmp/cookie "https://drive.google.com/uc?export=download&confirm=${CODE}&id=${FILE_ID}" -o aist_living_lab_1.zip
unzip aist_living_lab_1.zip


# run tracking and mapping
./run_video_slam -v ./orb_vocab/orb_vocab.dbow2 -m ./aist_living_lab_1/video.mp4 -c ./aist_living_lab_1/config.yaml --frame-skip 3 --no-sleep --map-db map.msg
# click the [Terminate] button to close the viewer
# you can find map.msg in the current directory
