# 1st master node

```
curl -sfL https://get.rke2.io | sh -
mkdir -p /etc/rancher/rke2/
cat << EOF > /etc/rancher/rke2/config.yaml
kube-apiserver-arg: "kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname"
tls-san:
  - mgmt01.support.tools
  - mgmt02.support.tools
  - mgmt03.support.tools
  - rke2-vip.support.tools
node-taint:
  - "CriticalAddonsOnly=true:NoExecute"
EOF
systemctl enable rke2-server.service
systemctl start rke2-server.service
```

# Capture the node token from the first node
```
cat /var/lib/rancher/rke2/server/node-token`
```

# 2nd, 3rd master nodes
```
curl -sfL https://get.rke2.io | sh -
mkdir -p /etc/rancher/rke2/
cat << EOF > /etc/rancher/rke2/config.yaml
kube-apiserver-arg: "kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname"
tls-san:
  - mgmt01.support.tools
  - mgmt02.support.tools
  - mgmt03.support.tools
  - rke2-vip.support.tools
node-taint:
  - "CriticalAddonsOnly=true:NoExecute"
server: https://<<Cluster DNS record>>:9345
token: <<Node Token goes here>>
EOF
systemctl enable rke2-server.service
systemctl start rke2-server.service
```

# Worker nodes
```
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -
mkdir -p /etc/rancher/rke2/
cat << EOF > /etc/rancher/rke2/config.yaml
server: https://<<Cluster DNS record>>:9345
token: <<Node Token goes here>>
EOF
systemctl enable rke2-agent.service
systemctl start rke2-agent.service
```