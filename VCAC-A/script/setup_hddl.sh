#!/bin/bash

#docker compose will keep container up even cross node reboot
run_hddl_compose()
{
    if test ! -x /usr/bin/docker-compose; then
        curl -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
        chmod +x /usr/bin/docker-compose
    fi

    mkdir -p /root/ov_hddl
    cd /root/ov_hddl
    gen_Dockercomposefile $1
    docker-compose up -d
}

gen_Dockercomposefile()
{
    cat > docker-compose.yml <<EOF
version: '2.4'
services:
  ov_hddl_init:
      image: openvisualcloud/vcaca-ubuntu1804-analytics-hddldaemon:$1
      command: [ "/bin/bash", "-c", "/usr/local/bin/init_hddl.sh;while true; do sleep 36000000;done" ]
      container_name: ov_hddl_init
      volumes:
        - /usr/src:/usr/src:ro
        - /lib/modules:/lib/modules
        - /etc/modules-load.d:/etc/modules-load.d
      restart: unless-stopped
      privileged: true
  ov_hddl_run:
      image: openvisualcloud/vcaca-ubuntu1804-analytics-hddldaemon:$1
      command: [ "/usr/local/bin/run_hddl.sh" ]
      container_name: ov_hddl_run
      device_cgroup_rules:
        - 'c 10:* rmw'
        - 'c 89:* rmw'
        - 'c 189:* rmw'
        - 'c 180:* rmw'
      volumes:
        - /dev:/dev
        - /var/tmp:/var/tmp
      restart: unless-stopped
      privileged: false
EOF
}

case "$0" in
    *install*)
        run_hddl_compose $1
        ;;
    *setup*)
        NODEUSER="root"
        for nodeip in $(sudo vcactl network ip 2>/dev/null | grep -E '^[0-9.]+$'); do
            echo "setup on $nodeip" $0
            scp "$0" $NODEUSER@$nodeip:/root/install-hddl.sh
            # install package on VCAC-A
            ssh $NODEUSER@$nodeip /root/install-hddl.sh ${1:-latest}
        done
        ;;
esac
