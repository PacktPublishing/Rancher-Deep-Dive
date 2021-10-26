```
                      +---------+
                      |End users|
                      +----+----+
                           |
                      +----v----+
                      |Route 53 |
                      +----+----+
                           |
              +------------v------------+
              | Network Load Balancer   |
              | TCP Mode                |
              |                         |
            +-+-------------------------+-+
            |                             |
            |                             |
+-----------v-------------+  +------------v------------+
|EKS Worker Node 01       |  |EKS Worker Node 02       |
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