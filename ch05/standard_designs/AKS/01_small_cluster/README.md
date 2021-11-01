```
          +---------+
          |End users|
          +----+----+
               |
               |
+--------------+--------------+
|Standard Load Balancer       |
|Type: Basic                  |
+--------------+--------------+
               |
               |
   +-----------v-------------+
   |AKS Worker Node 01       |
   +-------------------------+
   |Rancher Server pod       |
   |and other related pods   |
   |                         |
   +-------------------------+
   |Ingress-Nginx-Controller |
   +-------------------------+
   |Worker                   |
   +-------------------------+
```
