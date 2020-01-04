# Ubuntu VNC with ROS Melodic

This Image contains an Ubuntu 18.04 Xfce desktop environment and VNC/noVNC servers for headless use,  and also [ROS Melodic](https://www.ros.org/) Desktop with all dependencies already installed.

It is intended to be used in robot applications with simulator like [CoppeliaSim](http://www.coppeliarobotics.com/).

## Ports
Following TCP ports are exposed:

- **5901** used for access over **VNC**
- **6901** used for access over **noVNC**

The default **VNC user** password is **headless**.


## Credits

This image was primarily based on [accetto's ubuntu-vnc-xfce](https://hub.docker.com/r/accetto/ubuntu-vnc-xfce)

