### ospray Examples:
NOTICE: To run example xfrog-forest you have to uncomment line:
```bash
#include(ospray-example_xfrog.m4)
```
```bash
in file: "Xeon/your_os/ospray/Dockerfile.m4"
```
And then build image

NOTICE2: Image have to be run in GUI interface with params:
```bash
--network=host --env=DISPLAY
```
To run example please execute:
```bash
/home/ospray/build/ospExampleViewer /home/example/xfrog-forest.xml
```

NOTICE: In case of error:
```
Error 65544: X11: Failed to open display :0
terminate called after throwing an instance of 'std::runtime_error'
what():  Could not initialize glfw!
```
Please add this parameter for image
```
--volume="/home/<username>/.Xauthority:/root/.Xauthority:rw"
```
