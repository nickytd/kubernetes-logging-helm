Kubernetes Logging stack helm chart parameters

# Global values
  Parameter | Description  | Default  |
|---|---|---|
| cluster_name | opensearch cluster name  | "logging"  |
| imagePullSecrets | Array of secrets for private docker repositories | [] |
| storage_class | Default storage class for the persistent volumes. Each workload can overwrite the default value| "default" |
| priority_class | Default workloads priority class. Each workload can overwrite the default value | "logging" |

# opensearch nodes parameters

|  Parameter | Description  | Default  |
|---|---|---|
| opensearch.single_node | Set to true to use single all purpose elastic node. Coordination, data and maser node(s) are provisioned when "single_node" is set to false | false  |
| opensearch.in_cluster |  Set to true to provision an opensearch cluster. When false, an Opensearch url is required  | true  |
| opensearch.image | Opensearch image registry | "opensearchproject/opensearch" |
| opensearch.imageTag | Opensearch image tag | "1.0.1" |
| opensearch.imagePullPolicy | Sets container image pull policy | "IfNotPresent" |
| opensearch.saml.enabled | Set to true to enable SAML for opendistro | false |
| opensearch.saml.idp.metadata_url | SAML metadata URL | "" |
| opensearch.saml.idp.entity_id | SAML Identity Providfer entity id | "" |
| opensearch.saml.idp.cacerts | SAML Identity Providfer CA certificate | "" |
| opensearch.saml.sp.entity_id | SAML Service Provider entity id | "" |
| opensearch.saml.exchange_key | SAML exchange key | "" |
| opensearch.saml.admin_role | SAML role mapped to an opensearch administrator role| "" |
| opensearch.saml.viewer_role | SAML role mapped to an opensearch viewer role | "" |
| opensearch.saml.developer_role | SAML role mapped to an opensearch developer role | "" |
| opensearch.oidc.enabled | Set to true to enable OpenID for opendistro | false |
| opensearch.oidc.discovery_url | OpenID well known configuration URL | "" |
| opensearch.oidc.logout_url | OpenID logout URL | "" |
| opensearch.oidc.subject_key | OpenID subject key | "email" |
| opensearch.oidc.roles_key | OpenID roles key | "roles" |
| opensearch.oidc.scope | OpenID scope | "openid" |
| opensearch.oidc.admin_role | OpenID role mapped to an opensearch administrator role| "" |
| opensearch.oidc.viewer_role | OpenID role mapped to an opensearch viewer role | "" |
| opensearch.oidc.developer_role | OpenID role mapped to an opensearch developer role | "" |
| opensearch.oidc.cacerts | OpenID Identity Provider CA certificate | "" |
| opensearch.oidc.client_id | OpenID Identity Provider Client ID | "" |
| opensearch.oidc.client_secret | OpenID Identity Provider Client secret | "" |
| opensearch.oidc.verify_hostnames | OpenID Identity Provider hostname verification | true |
| opensearch.url | External Opensearch url. Required when "in_cluster" is set to false | "" |
| opensearch.retention_days | Opensearch index retention days. Older than the defined retention days indices are removed on a daily basis.  | 7 |
| opensearch.port | Default opensearch port | 9200 |
| opensearch.user | Default opensearch user with administrative privileges   | "osadmin" |
| opensearch.password | Password for the default opensearch user   | "osadmin" |
| opensearch.additional_jvm_params | Additional JVM parameters | "-Djava.net.preferIPv4Stack=true -XshowSettings:properties -XshowSettings:vm -XshowSettings:system" |
| opensearch.snapshot.enabled | Seto to true to enable opensearch snapshots | false |
| opensearch.snapshot.storage_class | The storage class for the snapshot volume. It needs to be a NFS share in a multi node setup. All nodes require access to the same share to be able to generate a snapshot | false |
| opensearch.snapshot.size | Snapshot volume size | "5Gi" |


# Opensearch Curator job configuration. 

Used for daily cron job operations. For example maintaining the index retention.

|  Parameter | Description  | Default  |
|---|---|---|
| os_curator.image | opensearch curator image registry | "nickytd/os-curator" |
| os_curator.imageTag | opensearch curator image tag | "5.8.4" |
| os_curator.imagePullPolicy | Sets container image pull policy | "IfNotPresent" |

# Init container configuration. 

Used for multiple application startup checks.

|  Parameter | Description  | Default  |
|---|---|---|
| init_container.image | Init container image registry | "nickytd/init-container" |
| init_container.imageTag |  Init container image tag | "0.1.0" |
| init_container.imagePullPolicy | Sets container image pull policy | "IfNotPresent" |

# Opensearch Master node configuration

|  Parameter | Description  | Default  |
|---|---|---|
| master.replicas | Number of opensearch master nodes | 1 |
| master.heap_size | JVM Heap size of an opensearch master node. The parameter value is set with jvm -Xmx setting. When pod resource limit is also defined, allow it to reflect the multiple pool sizes of the jvm. | "256m" |
| master.affinity | Pod affinity definition for the opensearch master nodes. Proposal: use pod anti-affinity configuration to spread master nodes on different cluster nodes | {} |
| master.priority_class | Priority class of the opensearch master node pods | "" |
| master.storage | Size of the persistent volume of an opensearch master node | "1Gi" |
| master.storage_class | Storage class of the opensearch master node persistence | "" |
| master.resources | Pod resource definition for the opensearch master nodes | {}  |
| master.tolerarions | opensearch master nodes pod affinity definition. Proposal: use pod anti-affinity configuration to spread master nodes on different cluster nodes. Cluster nodes count has to be equal or more than the replicas number | [] |

# Opensearch coordination node configuration

|  Parameter | Description  | Default  |
|---|---|---|
| client.replicas | Number of opensearch coordination nodes | 1 |
| client.heap_size | JVM Heap size of an opensearch coordination node | "512m" |
| client.ingress.enabled | Set to true to exposes opensearch http(s) endpoint as an ingress | false |
| client.ingress.path | Default context path for the ingress | "/" |
| client.ingress.annotations | Any additional ingress controller specific annotations | {} |
| client.ingress.tls | TLS ingress configuration | {} |
| client.affinity | Pod affinity definition for the opensearch coordination nodes  | {} |
| client.priority_class | Priority class of the opensearch coordination node pods | "" |
| client.resources | Pod resource definition for the opensearch coordination nodes | {} |
| client.tolerarions | Pod tolerations definition for the opensearch coordination nodes | [] |
| client.topologySpreadConstraints | opensearch coordination nodes scheduling spread configuration. If possible the workload can be evenly distributed among cluster nodes | {} |

# Opensearch Data node configuration

|  Parameter | Description  | Default  |
|---|---|---|
| data.replicas | Number of opensearch data nodes | 1 |
| data.heap_size | JVM Heap size of an opensearch data node | "512m" |
| data.affinity | opensearch data nodes pod affinity definition. Proposal: use pod anti-affinity configuration to spread data nodes on different cluster nodes. Cluster nodes count has to be equal or more than the replicas number | {} |
| data.priority_class | Priority class of the opensearch data node pods | "" |
| data.resources | Pod resource definition for the opensearch data nodes | {} |
| data.storage | Size of the persistent volume of an opensearch data node | "1Gi" |
| data.storage_class | Storage class of the opensearch data node persistence | "" |
| data.tolerarions | Pod tolerations definition for the opensearch data nodes | [] |

# opensearch-dashboards configuration

|  Parameter | Description  | Default  |
|---|---|---|
| opensearch-dashboards.in_cluster | Set to true to provision a opensearch-dashboards instance | true |
| opensearch-dashboards.url | Specifies external opensearch-dashboards URL when "in_cluster" is false | "" |
| opensearch-dashboards.replicas | Number of opensearch-dashboards instances | 1 |
| opensearch-dashboards.extraEnvs | Additional configuration for opensearch-dashboards | - name: "NODE_OPTIONS"<br />  value: "--max-old-space-size=350" |
| opensearch-dashboards.user | Default opensearch-dashboards user with administrative privileges | "opensearch-dashboards" |
| opensearch-dashboards.password | Password for the default opensearch-dashboards user | "opensearch-dashboards" |
| opensearch-dashboards.developer.user | User for the development tenant in opensearch-dashboards. The developer tenant can create searched and visualizations in the respective tenant space | "developer" |
| opensearch-dashboards.developer.password | Password for the developer user | "developer" |
| opensearch-dashboards.readonly.user | Readonly user in opensearch-dashboards | "viewer" |
| opensearch-dashboards.readonly.password | Password for the readonly user | "viewer" |
| opensearch-dashboards.ingress.enabled | When enabled exposes opensearch-dashboards endpoint as an ingress | false |
| opensearch-dashboards.ingress.path | Default context path for the ingress | "/" |
| opensearch-dashboards.ingress.annotations | Any additional ingress controller specific annotations | {} |
| opensearch-dashboards.ingress.tls | TLS ingress configuration | {} |
| opensearch-dashboards.index_patterns | Default set of opensearch-dashboards index patterns | ["containers", "systemd", "nginx"] |
| opensearch-dashboards.tenants | Preconfigured opensearch-dashboards tenants | ["Global", "Developer"] |
| opensearch-dashboards.affinity | opensearch-dashboards pod affinity definition | {} |
| opensearch-dashboards.priority_class | opensearch-dashboards pod priority class | "" |
| opensearch-dashboards.resources | opensearch-dashboards pod resource definition | {} |
| opensearch-dashboards.tolerarions | opensearch-dashboards pod tolerations definition | [] |


# Fluent-bit configuration

|  Parameter | Description  | Default  |
|---|---|---|
| fluentbit.image | Fluentbit image registry | "fluent/fluent-bit" |
| fluentbit.imageTag | Fluentbit image tag  | "1.8.1" |
| fluentbit.imagePullPolicy | Sets container image pull policy | "IfNotPresent" |
| fluentbit.host_path | Path location of the containers logs on the cluster nodes | "/var/log" |
| fluentbit.affinity | Fluentbit pod affinity definition | {} |
| fluentbit.priority_class | Fluentbit pod priority class | "" |
| fluentbit.resources | Fluentbit pod resource definition | {} |
| fluentbit.tolerarions | Fluentbit pod tolerations definition. All tainted nodes needs to be reflected in the tolerations array | [] |
| fluentbit.metrics.enabled | Set to true to enable Prometheus metrics. Requires Prometheus Operator | false |
| fluentbit.metrics.interval | Metrics scrape interval | "30s" |
| fluentbit.metrics.namespace | Namespace where servicemonitor is created | "" | 

# Fluentd configuration. 
Fluentd is supplied only when kafka.enabled is set to true.

|  Parameter | Description  | Default  |
|---|---|---|
| fluentd.image | Fluentd image registry | "nickytd/fluentd" |
| fluentd.imageTag | Fluentd image tag | "v1.13" |
| fluentd.imagePullPolicy | Sets container image pull policy | "IfNotPresent" |
| fluentd.replicas | Number of fluentd instances | 1 |
| fluentd.affinity | Fluentd pod affinity definition | {} |
| fluentd.extraEnvs | Additional configuration for fluentd | "" |
| fluentd.priority_class | Fluentd pod priority class | "" |
| fluentd.resources | Fluentd pod resource definition | {} |
| fluentd.tolerarions | Fluentd pod tolerations definition | [] |
| fluentd.topologySpreadConstraints | Fluentd scheduling spread configuration. If possible the workload can be evenly distributed among cluster nodes | {} |

# Kafka configuration. 
Kafka is used in scaled out scenario when a message broker is inserted on the logs stream.

|  Parameter | Description  | Default  |
|---|---|---|
| kafka.enabled | Set to true to enable kafka message broker and fluentd on the cluster log stream path | false |
| kafka.image | Kafka image registry| "wurstmeister/kafka" |
| kafka.imageTag | Kafka image tag | "2.13-2.7.0" |
| kafka.imagePullPolicy | Sets container image pull policy | "IfNotPresent" |
| kafka.replicas | Number of kafka brokers | 1 |
| kafka.heap_size | JVM Heap size of a kafka broker | "256m" |
| kafka.topics | Kafka broker topic configuration | config:<br /> "retention.bytes=134217728,retention.ms=3600000,message.timestamp.difference.max.ms=3600000,message.timestamp.type=LogAppendTime"<br /> name: ["containers"] |
| kafka.affinity | Kafka pod affinity definition. Proposal: use pod anti-affinity configuration to spread the kafka brokers on different cluster nodes. Cluster nodes count has to be equal or more than the replicas number | {} |
| kafka.priority_class | Kafka pod priority class | "" |
| kafka.resources | Kafka pod resource definition | {} |
| kafka.storage | Kafka broker persistent storage size | "1Gi" |
| kafka.storage_class | Storage class of the persistence volume | "1Gi" |
| kafka.tolerarions | Kafka pod tolerations definition | [] |


#Zookeeper is a dependency of kafka

|  Parameter | Description  | Default  |
|---|---|---|
| zookeeper.image | Image repository of the zookeeper container image | "zookeeper" |
| zookeeper.imageTag | Image tag of zookeeper container image | "3.7.0" |
| zookeeper.imagePullPolicy | Sets container image pull policy | "IfNotPresent" |
| zookeeper.replicas | Replicas of zookeeper statefulset | 1 |
| zookeeper.heap_size | JVM Heap size of a zookeeper node | "128m" |
| zookeeper.affinity | Zookeeper pod affinity definition. Proposal: use pod anti-affinity configuration to spread the zookeeper nodes on different cluster nodes. Cluster nodes count has to be equal or more than the replicas number | {} |
| zookeeper.priority_class | Zookeeper pod priority class | "" |
| zookeeper.resources | Zookeeper pod resource definition | {} |
| zookeeper.storage | Zookeeper pod persistent storage size | "1Gi" |
| zookeeper.storage_class | Storage class of the persistence volume | "1Gi" |
| zookeeper.tolerarions | Zookeeper pod tolerations definition | [] |

Example configuration:
 1. [single node setup](https://github.com/nickytd/kubernetes-logging-helm/blob/ddc174e6fef71e375f1e27fa3ce5188a2831aeb5/examples/single-node-setup.yaml)
 2. [multi node ha setup](https://github.com/nickytd/kubernetes-logging-helm/blob/ddc174e6fef71e375f1e27fa3ce5188a2831aeb5/examples/multi-node-ha-setup.yaml)
