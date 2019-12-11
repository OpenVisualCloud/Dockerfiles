#!/bin/bash

install_docker_engine()
{
    http_proxy="$1"
    https_proxy="$2"
    no_proxy="$3"
    dnss="$4"

    if [ ! -x "$(command -v docker)" ]; then
        echo "Installing docker......" 
        apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 
	export LC_ALL=C
        apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

	proxy_config=/etc/systemd/system/docker.service.d/http-proxy.conf
        if [ ! -f $proxy_config ]; then
	    mkdir -p $(dirname $proxy_config)
	    echo "[Service]" >> $proxy_config
	    echo "Environment=\"http_proxy=$http_proxy\" \"https_proxy=$https_proxy\" \"no_proxy=$no_proxy\"" >> $proxy_config
	    systemctl daemon-reload
            systemctl restart docker
        fi
	config_file=~/.docker/config.json
	if [ ! -f $config_file ]; then 
	    mkdir -p $(dirname "$config_file")
            cat > "$config_file" <<EOF
{
    "proxies": {
        "default": {
            "httpProxy": "$http_proxy", 
            "httpsProxy": "$https_proxy",
            "noProxy": "$no_proxy"
        }
    }
}
EOF
        fi
        
        daemon_json=/etc/docker/daemon.json
        if [ ! -f $daemon_json ]; then
	        echo "{\"dns\":[$dnss]}" >> $daemon_json
            mkdir -p $(dirname daemon_json)
            systemctl restart docker
        fi
    fi
}

case "$0" in 
    *install*)
        install_docker_engine "$@"
        ;;
    *setup*)
        sudo yum -y install NetworkManager
        systemctl start NetworkManager
        http_proxy=${http_proxy:-${HTTP_PROXY}}
        https_proxy=${https_proxy:-${HTTPS_PROXY}}
        no_proxy=${no_proxy:-${NO_PROXY}}
        dnss=$(nmcli dev show | awk '/IP4.DNS/{x=x","$NF}END{print substr(x,2)}')

        NODEUSER="root"
        NODEPREFIX="172.32"
        sudo vcactl blockio list 2> /dev/null
        for nodeip in $(sudo vcactl network ip |grep $NODEPREFIX 2>/dev/null); do
            echo "setup on $nodeip"
            scp "$0" $NODEUSER@$nodeip:/root/install-docker.sh
            ssh $NODEUSER@$nodeip /root/install-docker.sh "$http_proxy" "$https_proxy" "$no_proxy" "$dnss"
        done
        ;;
esac
