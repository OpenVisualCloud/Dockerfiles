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
