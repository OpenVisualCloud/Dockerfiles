### ospray+OpenImageIO+mpi:
NOTICE: To run example san-miguel you have to uncomment line:
```bash
#include(ospray-example_san-miguel.m4)
```
```bash
in file: "Xeon/your_os/ospray+mpi+OpenImageIO/Dockerfile.m4"
```
There are two options to see result:
1. Using single host calculation:

  Image have to be run in GUI interface with params:
  ```bash
  --network=host --env=DISPLAY
  ```
  To run example please execute:
```bash
/home/ospray/build/ospExampleViewer /home/example/sanm/sanm.obj \
 -vp 22.958788 3.204613 2.712676 -vu 0.000000 1.000000 0.000000 \
 -vi 12.364944 0.176316 4.009342 -sg:sun:intensity=4.0 \
 -sg:sun:direction=0,-1,0 -sg:bounce:intensity=0.0 \
 --hdri-light /home/example/rnl_probe.pfm \
 -sg:hdri:intensity=1.25 -r pt
```
2. Using multi-host calculation via MPI:

  On hosts which will only perform calculation i.e worker, image require one parameter with executing sshd, for example:
  ```bash
docker run --net=host -it xeon_ubuntu1604_ospray-mpi /usr/sbin/sshd -D
  ```
  On host which will show results i.e master,
  Image have to be run in GUI interface with params:
  ```bash
  --network=host --env=DISPLAY
  ```
  Inside "master" image please execute:
  ```bash
mpirun -n /*your number of hosts*/ -ppn 1 \
-host=<master-ip,worker1-ip,worker2-ip,...>  \
/home/ospray/build/ospExampleViewer /home/example/sanm/sanm.obj \
 -vp 22.958788 3.204613 2.712676 -vu 0.000000 1.000000 0.000000 \
 -vi 12.364944 0.176316 4.009342 -sg:sun:intensity=4.0 \
 -sg:sun:direction=0,-1,0 -sg:bounce:intensity=0.0 \
 --hdri-light /home/example/rnl_probe.pfm \
 -sg:hdri:intensity=1.25 -r pt --osp:mpi
  ```
  NOTICE-1: Multi-host connection is configured on port 2222, please make sure if it is avaliable on your hosts

  NOTICE-2: Images are not interchangeable, which means workers and master have to be the same image for example "xeon_ubuntu1604_ospray-mpi"

  NOTICE-3: In case of error:
  ```
  Error 65544: X11: Failed to open display :0
  terminate called after throwing an instance of 'std::runtime_error'
  what():  Could not initialize glfw!
  ```
  Please add this parameter for master image
  ```
  --volume="/home/<username>/.Xauthority:/root/.Xauthority:rw"
  ```
