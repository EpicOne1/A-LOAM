#!/bin/bash
# trap : SIGTERM SIGINT

function abspath() {
    # generate absolute path from relative path
    # $1     : relative filename
    # return : absolute path
    if [ -d "$1" ]; then
        # dir
        (cd "$1"; pwd)
    elif [ -f "$1" ]; then
        # file
        if [[ $1 = /* ]]; then
            echo "$1"
        elif [[ $1 == */* ]]; then
            echo "$(cd "${1%/*}"; pwd)/${1##*/}"
        else
            echo "$(pwd)/$1"
        fi
    fi
}

# if [ "$#" -ne 1 ]; then
#   echo "Usage: $0 LIDAR_SCAN_NUMBER" >&2
#   exit 1
# fi

# roscore &
# ROSCORE_PID=$!
# sleep 1

# rviz -d ../rviz_cfg/aloam_velodyne.rviz &
# RVIZ_PID=$!

# A_LOAM_DIR=$(abspath "..")

# if [ "$1" -eq 16 ]; then
#     docker run \
#     -it \
#     --rm \
#     --net=host \
#     -v ${A_LOAM_DIR}:/root/catkin_ws/src/A-LOAM/ \
#     ros:aloam \
#     /bin/bash -c \
#     "cd /root/catkin_ws/; \
#     catkin config \
#         --cmake-args \
#             -DCMAKE_BUILD_TYPE=Release; \
#         catkin build; \
#         source devel/setup.bash; \
#         roslaunch aloam_velodyne aloam_velodyne_VLP_16.launch rviz:=false"
# elif [ "$1" -eq "32" ]; then
#     docker run \
#     -it \
#     --rm \
#     --net=host \
#     -v ${A_LOAM_DIR}:/root/catkin_ws/src/A-LOAM/ \
#     ros:aloam \
#     /bin/bash -c \
#     "cd /root/catkin_ws/; \
#     catkin config \
#         --cmake-args \
#             -DCMAKE_BUILD_TYPE=Release; \
#         catkin build; \
#         source devel/setup.bash; \
#         roslaunch aloam_velodyne aloam_velodyne_HDL_32.launch rviz:=false"
# elif [ "$1" -eq "64" ]; then
#     docker run \
#     -it \
#     --rm \
#     --net=host \
#     -v ${A_LOAM_DIR}:/root/catkin_ws/src/A-LOAM/ \
#     ros:aloam \
#     /bin/bash -c \
#     "cd /root/catkin_ws/; \
#     catkin config \
#         --cmake-args \
#             -DCMAKE_BUILD_TYPE=Release; \
#         catkin build; \
#         source devel/setup.bash; \
#         roslaunch aloam_velodyne aloam_velodyne_HDL_64.launch rviz:=false"
# fi

# wait $ROSCORE_PID
# wait $RVIZ_PID

# if [[ $? -gt 128 ]]
# then
#     kill $ROSCORE_PID
#     kill $RVIZ_PID
# fi

A_LOAM_DIR=$(abspath "..")
docker run -it --privileged --net=host --ipc=host --device=/dev/dri:/dev/dri \
    --env="DISPLAY=$DISPLAY" \
    --env QT_X11_NO_MITSHM=1 \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /home/$USER/.Xauthority:/home/ljy/.Xauthority:rw \
    -e ROS_IP=127.0.0.1 \
    --gpus all \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
    -e NVIDIA_VISIBLE_DEVICES=all \
    -v ${A_LOAM_DIR}:/root/catkin_ws/src/A-LOAM/ \
    -v /home/ljy/SLAM/LOAM_NOTED/:/root/catkin_ws/src/LOAM_NOTED/ \
    --name aloam ros:aloam /bin/bash