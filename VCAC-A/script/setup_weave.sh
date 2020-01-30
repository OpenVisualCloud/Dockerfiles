#!/bin/bash -e

if test -z "$1"; then
    echo "Usage: <master> [IP-RANGE]"
    exit -3
fi

echo "Create /etc/weave.conf"
sudo tee /etc/weave.conf <<EOF
PEERS="$1"
IP_RANGE="${2:-172.30.0.0/16}"
EOF

echo "Download the WeaveNet software"
sudo curl -L git.io/weave -o /usr/local/bin/weave
sudo chmod a+x /usr/local/bin/weave

echo "Setup weave.service"
sudo tee /etc/systemd/system/weave.service <<EOF
[Unit]
Description=Weave Network
Documentation=http://docs.weave.works/weave/latest_release/
Requires=docker.service
After=docker.service
Before=kubelet.service

[Service]
EnvironmentFile=/etc/weave.conf
ExecStartPre=/usr/local/bin/weave reset --force
ExecStartPre=/usr/local/bin/weave launch --no-restart --ipalloc-range=\${IP_RANGE} \$PEERS
ExecStartPre=/bin/sh -c 'echo KUBELET_EXTRA_ARGS=\\\\\"--node-ip=\$\$(/usr/local/bin/weave expose)\\\\\" > /etc/default/kubelet'
ExecStart=/usr/bin/docker attach weave
ExecStop=/usr/local/bin/weave stop

[Install]
WantedBy=multi-user.target
EOF

echo "Enable weave.service"
sudo systemctl daemon-reload
sudo systemctl enable weave.service

echo "Start weave.service"
sudo systemctl stop weave.service
sudo systemctl start weave.service

echo "This node IP: $(/usr/local/bin/weave expose)"
