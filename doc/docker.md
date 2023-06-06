### Docker installation suggetion
It is recommended to install docker according to the [official steps](https://docs.docker.com/engine/install/). Those low version or pre-release version may cause unexpected issues.

### Docker build and running suggestion
It is recommended to use official images as base images. Please do not setup docker registry manually, neither set the file in /etc/docker , or it may use 3rd-party source and install different version components such as `libstdc++6.so`, which will cause some failure.