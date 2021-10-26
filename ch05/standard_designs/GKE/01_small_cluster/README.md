```
                      +---------+
                      |End users|
                      +----+----+
                           |
                           |
            +--------------+--------------+
            |Google Cloud Load Balancers  |
            |Type:                        |
            |Internal HTTPS Load Balancing|
            +-----------------------------+
            |                             |
            |                             |
+-----------v-------------+  +------------v------------+
|GKE Worker Node 01       |  |GKE Worker Node 02       |
+-------------------------+  +-------------------------+
|Rancher Server pod       |  |Rancher Server pod       |
|and other related pods   |  |and other related pods   |
|                         |  |                         |
+-------------------------+  +-------------------------+
|Ingress-Nginx-Controller |  |Ingress-Nginx-Controller |
+-------------------------+  +-------------------------+
|Worker                   |  |Worker                   |
+-------------------------+  +-------------------------+
```
