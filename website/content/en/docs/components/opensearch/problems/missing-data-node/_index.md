---
title: "Missing data node"
linkTitle: "Missing data node"
weight: 10
type: "docs"
---

# Prerequisites

In this guide I expect, that you have access to Kubernetes cluster and have portfoward to some *OpenSearch node* (= pod from Kubernetes perspective). I recommend chose one node *client* type.<br>
All API call to OpenSearch cluster beginning: `curl -ks https://<Name>:<Password>@localhost:9200/<Source>`, where:
  - `<Name>` = user name in OpenSearch cluster with admin privileges
  - `<Password>` = corespondig password for admin account
  - `<Source>` = datapoint from OpenSearch cluster

1. Check current status:
  ```bash
  $ curl -ks https://<Name>:<Password>@localhost:9200/_cat/health

  1654179496 14:18:16 logging yellow 5 1 true 30 30 0 0 27 0 - 52.6%
  ```
  > our cluster is in **yellow** state

2. List all available nodes from OpenSearch perspective:
  ```bash
  $ curl -ks https://<Name>:<Password>@localhost:9200/_cat/nodes
  100.96.7.5  72  97 1 0.30 0.36 0.35 mr  - ofd-manager-0
  100.96.7.11 51  76 1 0.30 0.36 0.35 r   - ofd-client-56dd9c66fb-bs7hp
  100.96.7.7  53  76 4 0.30 0.36 0.35 dir - ofd-data-1
  100.96.1.8  21 100 1 1.73 0.82 0.41 mr  * ofd-manager-1
  100.96.7.12 19  76 1 0.30 0.36 0.35 r   - ofd-client-56dd9c66fb-q9tv5
  ```
  > here you can see multinode setup, where must exist two nodes from type *client*, *data* and *manager* (6 OpenSearch nodes total)<br>
  >
  > one datanode "ofd-data-0" is missing

3. Check suspicious pods:
  ```bash
  $ kubectl -n logging get pods | grep data
  ofd-data-0    1/1    Running    0    130m
  ofd-data-1    1/1    Running    0    129m
  ```
  > from Kubernetes perspective this pods (OpenSearch node) working fine

4. Check logs from suspicious pod:
  ```bash
  $ kubectl -n logging logs ofd-data-0
  ...
  "message": "failed to join ...
  ...
  Caused by: org.opensearch.cluster.coordination.CoordinationStateRejectedException: join validation on cluster state with a different cluster uuid 2UlST0WBQIKEV05cDpuWwQ than local cluster uuid v1vi49Q_RRaaC83iMthBnQ, rejecting
  ...
  ```
  > it seems, that this node hold old previously used OpenSearch cluster ID and attempt to connect to this old OpenSearch cluster instance
  >
  > **this is reason, why this node is missing**

5. Reset failed data node:
  {{< alert color="warning" title="Warning" >}}**Double check, that you have at last half data nodes healthy!** In our case, we must have 2 data nodes total and 1 is missing. **Double check, that OpenSearch cluster is in yellow state. Proceeding with smaller amount of datanodes come to datalost!**{{< /alert >}}
  - login to this pod:
    ```bash
    $ kubectl -n logging exec -i -t ofd-data-0 -- /bin/bash
    ```
  - delete datadir in this pod:
    ```bash
    $ rm -rf /data/nodes
    ```
  - logout from this pod:
    ```bash
    $ exit
    ```
  - delete this pod for restarting:
    ```bash
    $ k -n logging delete pod ofd-data-0
    pod "ofd-data-0" deleted
    ```

6. Check OpenSearch cluster health again:
  ```bash
  $ curl -ks https://<Name>:<Password>@localhost:9200/_cat/health
  1654180648 14:37:28 logging yellow 6 2 true 45 30 0 4 11 0 - 75.0%
  ...
  1654180664 14:37:44 logging yellow 6 2 true 53 30 0 2 5 0 - 88.3%
  ...
  1654180852 14:40:52 logging green 6 2 true 60 30 0 0 0 0 - 100.0%
  ```
  > our cluster is still in yellow state
  >
  > running `curl` command over time give information, that cluster regenerating
  >
  > wait some time and if this problem was solved, you can see cluster again healthy in *green* state
