```
                                         +---------+
                                         |End users|
                                         +----+----+
                                              |
                                 +------------v------------+
                                 | Network Load Balancer   |
                                 | TCP Mode                |
                                 |                         |
              +------------------+------------+------------+-------------------+
              |                               |                                |
+-------------v---------------+  +------------v----------------+ +-------------v---------------+
|  Node Pool: Worker A        |  |  Node Pool: Worker B        | |  Node Pool: Worker C        |
|  Zone: US West 2A           |  |  Zone: US West 2B           | |  Zone: US West 2C           |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
| |RKE Worker 01            | |  | |RKE Worker 01            | | | |RKE Worker 01            | |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
| |User application pods    | |  | |User application pods    | | | |User application pods    | |
| |                         | |  | |                         | | | |                         | |
| |                         | |  | |                         | | | |                         | |
| |                         | |  | |                         | | | |                         | |
| |                         | |  | |                         | | | |                         | |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
| |Ingress-Nginx-Controller | |  | |Ingress-Nginx-Controller | | | |Ingress-Nginx-Controller | |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
| |Worker                   | |  | |Worker                   | | | |Worker                   | |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
|                             |  |                             | |                             |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
| |RKE Worker 02            | |  | |RKE Worker 02            | | | |RKE Worker 02            | |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
| |User application pods    | |  | |User application pods    | | | |User application pods    | |
| |                         | |  | |                         | | | |                         | |
| |                         | |  | |                         | | | |                         | |
| |                         | |  | |                         | | | |                         | |
| |                         | |  | |                         | | | |                         | |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
| |Ingress-Nginx-Controller | |  | |Ingress-Nginx-Controller | | | |Ingress-Nginx-Controller | |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
| |Worker                   | |  | |Worker                   | | | |Worker                   | |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
|                             |  |                             | |                             |
+-----------------------------+  +-----------------------------+ +-----------------------------+

+-----------------------------+  +-----------------------------+ +-----------------------------+
|  Node Pool: Mgmt A          |  |  Node Pool: Mgmt B          | |  Node Pool: Mgmt C          |
|  Zone: US West 2A           |  |  Zone: US West 2B           | |  Zone: US West 2C           |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
| |RKE mgmt a01             | |  | |RKE mgmt b01             | | | |RKE mgmt c01             | |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
| |etcd                     | |  | |etcd                     | | | |etcd                     | |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
| |controlplane             | |  | |controlplane             | | | |controlplane             | |
| +-------------------------+ |  | +-------------------------+ | | +-------------------------+ |
|                             |  |                             | |                             |
+-----------------------------+  +-----------------------------+ +-----------------------------+
```