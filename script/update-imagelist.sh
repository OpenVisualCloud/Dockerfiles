#!/bin/bash -e

if [ -z "$2" ]; then
    echo "Usage: <prefix> <platform>"
    exit -1
fi 

test -f README.md
echo "Updating $2/README.md..."
mv -f README.md README.tmp
awk -v prefix=$1 -v platform1=$2 -- '
BEGIN {
    nos=split("ubuntu-18.04 ubuntu-16.04 centos-7.6 centos-7.5 centos-7.4",os," ");
    nusage=split("media analytics graphics service",usage," ");
    nimage=split("ffmpeg gst nginx ospray ospray-mpi owt owt-immersive dev",image," ");
    imagelist=0;
}
imagelist==1 && !/^\|.*\|$/ {
    imagelist=0;
    print "|---|---|---|";
    for (u1=1;u1<=nusage;u1++) {
        usage1=usage[u1];
        for (i1=1;i1<=nimage;i1++) {
            image1=image[i1];
            c2=c3="";
            for (o1=1;o1<=nos;o1++) {
                os1=os2=os[o1];
                gsub(/[-.]/,"",os2);
                if (system("test -d "os1"/"usage1"/"image1)!=0) continue;
                c2=c2"<br>["os1"/"usage1"/"image1"]("os1"/"usage1"/"image1")";
                c3=c3"<br>";
                image2=prefix"/"platform1"-"os2"-"usage1"-"image1;
                if (system("curl --silent -f -lSL -o /dev/null https://hub.docker.com/v2/repositories/"image2"/tags/latest")==0)
                    c3=c3"["image2"](https://hub.docker.com/r/"image2")";
            }
            if (length(c2)==0) continue;
            print "|"usage1"-"image1"|"substr(c2,5)"|"substr(c3,5)"|";
        }
    }
}
imagelist==0 {
    print $0;
}
/^\|Image\|Dockerfile\|Docker Image\|$/ {
    imagelist=1;
}
' README.tmp > README.md 2> /dev/null
rm -f README.tmp
