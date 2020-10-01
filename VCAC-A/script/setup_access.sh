#!/bin/bash -e

case "$0" in 
    *install*)
        http_proxy="$1"
        https_proxy="$2"
        no_proxy="$3"

        proxy_config=/etc/apt/apt.conf.d/99proxy
        if [ ! -f $proxy_config ]; then
            echo "Acquire:http:Proxy \"$http_proxy\";" > $proxy_config
        fi

        env_config=/etc/environment
        if [ -z "$(grep -E '_(proxy|PROXY)=' $env_config)" ]; then
            echo "http_proxy=\"$http_proxy\"" >> $env_config
            echo "https_proxy=\"$https_proxy\"" >> $env_config
            echo "no_proxy=\"$no_proxy\"" >> $env_config
        fi
        ;; 
    *setup*)
        if test ! -f ~/.ssh/id_rsa; then
            cat /dev/zero | ssh-keygen -q -N ""
        fi

        # Setup network
        sudo sysctl -w net.ipv4.ip_forward=1

        # Setup proxy & time
        http_proxy=${http_proxy:-${HTTP_PROXY}}
        https_proxy=${https_proxy:-${HTTPS_PROXY}}
        no_proxy=${no_proxy:-${NO_PROXY}}

        NODEUSER="root"
        for nodeinfo in $(sudo vcactl config-show | awk '/host-ip:/{hi=$2}/host-mask:/{hm=$2;print ip","hi"/"hm}$1=="ip:"{ip=$2}'); do

            # Setup network
            nodenet=$(echo $nodeinfo | cut -f2 -d,)
            nodeint=$(sudo ip -4 address show | awk -v net=$nodenet '/^[0-9]+:/{name=$2}/inet /&&$2==net{print name}' | cut -f1 -d:)
            sudo iptables -t nat -A POSTROUTING -s $nodenet -d 0/0 -j MASQUERADE
            sudo iptables -I FORWARD -j ACCEPT -i $nodeint
            sudo iptables -I FORWARD -j ACCEPT -o $nodeint

            # Setup address
            nodeip=$(echo $nodeinfo | cut -f1 -d,)
            ssh-copy-id $NODEUSER@${nodeip} 2> /dev/null || echo
            scp /etc/resolv.conf $NODEUSER@$nodeip:/etc/resolv.conf
            ssh $NODEUSER@$nodeip "date -s \"$(date)\""
            scp "$0" $NODEUSER@$nodeip:/root/install-access.sh
            ssh $NODEUSER@$nodeip /root/install-access.sh "$http_proxy" "$https_proxy" "$no_proxy"
            ssh $NODEUSER@$nodeip "if [ \$(dpkg-query --show | grep '^\(dbus\|tzdata\)' | wc -l) != '2' ]; then apt-get update && apt-get install -y dbus tzdata; fi"
            ssh $NODEUSER@$nodeip "timedatectl set-timezone \"$(timedatectl | awk '/Time zone:/{print$3}')\""

        done
        ;;
esac


