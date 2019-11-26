#!/bin/bash -e
NODEPREFIX="172.32"
function transfer_image {
    image="$1"
    nodeip="$2"

    # trasnfer VCAC-A images to VCAC-A nodes only
    if [[ -n "$(echo $nodeip | grep ${NODEPREFIX})" ]] || [[ "$(id -u)" -eq "0" ]]; then
    	worker="root@$nodeip"
    else
    	worker="$nodeip"
    fi

    echo "Update image: $image to $worker"
    sig1=$(docker image inspect -f {{.ID}} $image)
    echo " local: $sig1"

    sig2=$(ssh $worker "docker image inspect -f {{.ID}} $image 2> /dev/null || echo")
    echo "remote: $sig2"

    if test "$sig1" != "$sig2"; then
    	echo "Transfering image..."
    	docker save $image | ssh $worker "docker image rm -f $image 2>/dev/null; docker load"
    fi
    echo ""
}

IMAGE=""
if [ -z $1 ]; then
    IMAGE=openvisualcloud/vcaca-ubuntu1604-analytics-ffmpeg:latest
else
    IMAGE=$1
fi

for id in $(docker node ls -q 2> /dev/null); do
    ready="$(docker node inspect -f {{.Status.State}} $id)"
    active="$(docker node inspect -f {{.Spec.Availability}} $id)"
    nodeip="$(docker node inspect -f {{.Status.Addr}} $id)"
    labels="$(docker node inspect -f {{.Spec.Labels}} $id | sed 's/map\[/node.labels./' | sed 's/\]$//' | sed 's/ / node.labels./g' | sed 's/:/==/g')"
    role="$(docker node inspect -f {{.Spec.Role}} $id)"

    if test "$ready" = "ready"; then
    	if test "$active" = "active"; then
    	     # skip unavailable or manager node
    	     if test -z "$(hostname -I | grep --fixed-strings $nodeip)"; then
    	     	 transfer_image $IMAGE "$nodeip"
    	     fi
    	fi
    fi
done
