## Custom Dockerfile
FROM accetto/ubuntu-vnc-xfce


# Switch to root user to install additional software
USER 0

## Install a gedit
RUN apt update --fix-missing -y \
    && apt install -y gedit \
    && apt clean all

RUN apt install curl -y 

RUN touch /etc/apt/sources.list.d/ros-latest.list


RUN apt-get install software-properties-common -y \
    && add-apt-repository restricted \
    && add-apt-repository universe \
    && add-apt-repository multiverse \ 
    && apt update -y


# ========================== General Ubuntu Settings ==========================
#

RUN printf '\n\n Applying melodic-ros-base settings .. \n\n'

#
# Define script parameters
#
ARG shell=/bin/bash

# Use /bin/bash instead of /bin/sh
RUN mv /bin/sh /bin/sh-old && \
ln -s /bin/bash /bin/sh

# Set timezone based on your location
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install apt-utils, git, python3, pip3
RUN apt-get update -y && apt-get install -y \ 
python3-pip python3-yaml python3-dev python3-numpy libopencv-dev net-tools less nano \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean


#
# ========================== ROS Setup ==========================
#

RUN printf '\n\n Installing Python3 necessary libraries .. \n\n'

# Install Python3 libraries
RUN pip3 install -U rospkg catkin_pkg Pillow six numpy opencv-contrib-python empy PyQt5 pyquaternion 

# Use ONLY this specific version of vcstool
RUN git clone -b mock_server_tar_test https://github.com/tkruse/vcstools.git \
&& pip3 install ./vcstools/




# Link python 3 dist to site pckgs
RUN ln -s /usr/local/lib/python3.6/dist-packages /usr/local/lib/python3.6/site-packages


RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list' \
    && curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add - \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y apt-utils \
    && apt-get install ros-melodic-desktop-full -y

# Install rosdep to deal with dependencies of further ROS packages
RUN rm -rf /etc/ros/rosdep/sources.list.d/* \
    && rosdep init \
    && rosdep fix-permissions -y \
    && rosdep update -y

RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc 
    #&& source ~/.bashrc 

RUN apt install python-rosinstall python-rosinstall-generator python-wstool build-essential -y

RUN wget http://packages.ros.org/ros.key -O - | sudo apt-key add -

RUN apt-get install python-catkin-tools python-catkin-pkg -y

#RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
#    python get-pip.py

RUN apt autoremove -y

#RUN export PYTHONPATH=$PYTHONPATH:/usr/lib/python2.7/dist-packages

## switch back to default user
#USER 1000
USER 0
