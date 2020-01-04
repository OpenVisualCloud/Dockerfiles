#!/bin/bash -e

# setup host docker swarm if not already
docker swarm leave --force 2> /dev/null
docker swarm init --advertise-addr=$(hostname -i) 2> /dev/null || echo
JOINCMD=$(docker swarm join-token worker | grep token)

# setup VCAC-A passwordless access
echo "Login to VACA-A once to establish passwordless access"
if test ! -f ~/.ssh/id_rsa; then
    cat /dev/zero | ssh-keygen -q -N ""
    echo
fi

NODEUSER="root"
# setup node to join the host docker swarm
NODES="$(sudo vcactl network ip 2>/dev/null | grep -E '^[0-9.]+$')"
for nodeip in $NODES; do
    ssh-copy-id $NODEUSER@${nodeip} 2> /dev/null || echo
    echo "Node: $nodeip"
    ssh $NODEUSER@${nodeip} "docker swarm leave --force 2> /dev/null;$JOINCMD"
done

# setup node labels
for id in $(docker node ls -q 2> /dev/null); do
    nodeip="$(docker node inspect -f {{.Status.Addr}} $id)"
    if test -n "$(echo $NODES | grep --fixed-strings $nodeip)"; then
        echo "label $id: vcac_zone=yes"
        docker node update --label-add vcac_zone=yes $id
    fi
done
