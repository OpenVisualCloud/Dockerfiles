#!/bin/bash -e

if [ -z "$2" ]; then
    echo "Usage: <prefix> <platform>"
    exit -1
fi 

test -f README.md
echo "Updating $2/README.md..."
mv -f README.md README.tmp

awk -v prefix=$1 -v platform1=$2 -v images="$(find . -maxdepth 3 -mindepth 3 -type d -print | cut -f2-4 -d'/')" -- '
BEGIN {
    split(images,images2," ");
    for (image1 in images2) {
        split(images2[image1],parts,"/");
        os[parts[1]]=1;
        usage[parts[2]]=1;
        image[parts[3]]=1;
        dockerfile[images2[image1]]=1;
    }
    asorti(os);
    asorti(usage);
    asorti(image);
    imagelist=0;
}
imagelist==1 && !/^\|.*\|$/ {
    imagelist=0;
    print "|:-:|---|---|";
    for (u1 in usage) {
        usage1=usage[u1];
        for (i1 in image) {
            image1=image[i1];
            c2=c3="";
            for (o1 in os) {
                os2=os1=os[o1];
                gsub(/[-.]/,"",os2);
                if (!dockerfile[os1"/"usage1"/"image1]) continue;
                c2=c2"<br>["os1"/"usage1"/"image1"]("os1"/"usage1"/"image1")";
                image2=prefix"/"platform1"-"os2"-"usage1"-"image1;
                if (system("curl --silent -f -lSL -o /dev/null https://hub.docker.com/v2/repositories/"image2"/tags/latest")==0) {
                    c3=c3"<br>["image2"](https://hub.docker.com/r/"image2")";
                } else {
                    c3=c3"<br>";
                }
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
