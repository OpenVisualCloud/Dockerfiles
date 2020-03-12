#!/bin/bash -e

# setup host docker swarm if not already
docker swarm leave --force 2> /dev/null || true
docker swarm init --advertise-addr=${1:-$(sudo vcactl config-show |awk '/gateway/{print$2;exit}')} 2>/dev/null || true
JOINCMD=$(docker swarm join-token worker | grep token)

NODEUSER="root"
# setup node to join the host docker swarm
NODES="$(sudo vcactl network ip 2>/dev/null | grep -E '^[0-9.]+$')"
for nodeip in $NODES; do
    echo "Node: $nodeip"
    ssh $NODEUSER@${nodeip} "docker swarm leave --force 2> /dev/null;$JOINCMD"
done

# setup node labels
for id in $(docker node ls -q 2>/dev/null); do
    nodename="$(docker node inspect -f {{.Description.Hostname}} $id)"
    if test -n "$(sudo vcactl config-show | awk -v name=$nodename '/node-name:/&&$2==name{print 1}')"; then
        echo "label $nodename: vcac_zone=yes"
        docker node update --label-add vcac_zone=yes $id
    fi
done
