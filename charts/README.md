Kubernetes Logging stack helm chart parameters

# Global values
  Parameter | Description  | Default  |
|---|---|---|
|  cluster_name | Elasticsearch cluster name  | "logging"  |
|  imagePullSecrets | Array of secrets for private docker repositories | [] |
|  storage_class | Default storage class for the persistent volumes. Each workload can overwrite the default value| "standard" |
|  priority_class | Default workloads priority class. Each workload can overwrite the default value | "logging" |

# Elasticsearch nodes parameters

|  Parameter | Description  | Default  |
|---|---|---|
|  elasticsearch.single_node | Set to true to use single all purpose elastic node. Coordination, data and maser node(s) are provisioned when "single_node" is set to false | false  |
|  elasticsearch.in_cluster |  Set to true to provision an elasticsearch cluster. When false, an ES url is required  | true  |
|  elasticsearch.url | External ES url. Required when "in_cluster" is set to false | "" |
|  elasticsearch.retention_days | Elasticsearch index retention days. Older than the defined retention days indices are removed on a daily basis.  | 7 |
|  elasticsearch.port | Default elasticsearch port | 9200 |
|  elasticsearch.user | Default elasticsearch user with administrative privileges   | "esadmin" |
|  elasticsearch.password | Password for the default elasticsearch user   | "esadmin" |
|  elasticsearch.additional_jvm_params | Additional JVM parameters | "-Djava.net.preferIPv4Stack=true -XshowSettings:properties -XshowSettings:vm -XshowSettings:system" |
|  elasticsearch.snapshot.enabled | Seto to true to enable elasticsearch snapshots | false |
|  elasticsearch.snapshot.storage_class | The storage class for the snapshot volume. It needs to be a NFS share in a multi node setup. All nodes require access to the same share to be able to generate a snapshot | false |
|  elasticsearch.snapshot.size | Snapshot volume size | "5Gi" |


# Opendistro configuration
|  Parameter | Description  | Default  |
|---|---|---|
|  opendistro.image | Opendistro image registry | "amazon/opendistro-for-elasticsearch" |
|  opendistro.imageTag | Opendistro image tag | "1.13.2" |
|  opendistro.saml.enabled | Set to true to enable SAML for opendistro | false |
|  opendistro.saml.idp.metadata_url | SAML metadata URL | "" |
|  opendistro.saml.idp.entity_id | SAML Identity Providfer entity id | "" |
|  opendistro.saml.sp.entity_id | SAML Service Provider entity id | "" |
|  opendistro.saml.exchange_key | SAML exchange key | "" |
|  opendistro.saml.admin_role | SAML role mapped to an elastic administrator role| "" |
|  opendistro.saml.viewer_role | SAML role mapped to an elastic viewer role | "" |
|  opendistro.saml.tenant_role | SAML role mapped to an elastic tenant role | "" |


# ES Curator job configuration. 

Used for daily cron job operations. For example maintaining the index retention.

|  Parameter | Description  | Default  |
|---|---|---|
|  es_curator.image | Elasticsearch curator image registry | "nickytd/es-curator" |
|  es_curator.imageTag | Elasticsearch curator image tag | "5.8" |

# Init container configuration. 

Used for multiple application startup checks.

|  Parameter | Description  | Default  |
|---|---|---|
|  init_container.image | Init container image registry | "nickytd/init-container" |
|  init_container.imageTag |  Init container image tag | "0.1.0" |
|  init_container.imagePullPolicy |  Init container pull policy | "IfNotPresent" |

# ES Master node configuration

|  Parameter | Description  | Default  |
|---|---|---|
| master.replicas | Number of elasticsearch master nodes | 1 |
| master.heap_size | JVM Heap size of an elasticsearch master node. The parameter value is set with jvm -Xmx setting. When pod resource limit is also defined, allow it to reflect the multiple pool sizes of the jvm. | "256m" |
| master.affinity | Pod affinity definition for the elasticsearch master nodes. Proposal: use pod anti-affinity configuration to spread master nodes on different cluster nodes | {} |
| master.priority_class | Priority class of the elasticsearch master node pods | "" |
| master.storage | Size of the persistent volume of an elasticsearch master node | "1Gi" |
| master.storage_class | Storage class of the elasticsearch master node persistence | "" |
| master.resources | Pod resource definition for the elasticsearch master nodes | {}  |
| master.tolerarions | Elasticsearch master nodes pod affinity definition. Proposal: use pod anti-affinity configuration to spread master nodes on different cluster nodes. Cluster nodes count has to be equal or more than the replicas number | [] |

# ES coordination node configuration

|  Parameter | Description  | Default  |
|---|---|---|
| client.replicas | Number of elasticsearch coordination nodes | 1 |
| client.heap_size | JVM Heap size of an elasticsearch coordination node | "512m" |
| client.ingress.enabled | Set to true to exposes elasticsearch http(s) endpoint as an ingress | false |
| client.ingress.path | Default context path for the ingress | "/" |
| client.ingress.annotations | Any additional ingress controller specific annotations | {} |
| client.ingress.tls | TLS ingress configuration | {} |
| client.affinity | Pod affinity definition for the elasticsearch coordination nodes  | {} |
| client.priority_class | Priority class of the elasticsearch coordination node pods | "" |
| client.resources | Pod resource definition for the elasticsearch coordination nodes | {} |
| client.tolerarions | Pod tolerations definition for the elasticsearch coordination nodes | [] |
| client.topologySpreadConstraints | Elasticsearch coordination nodes scheduling spread configuration. If possible the workload can be evenly distributed among cluster nodes | {} |

# ES Data node configuration

|  Parameter | Description  | Default  |
|---|---|---|
| data.replicas | Number of elasticsearch data nodes | 1 |
| data.heap_size | JVM Heap size of an elasticsearch data node | "512m" |
| data.affinity | Elasticsearch data nodes pod affinity definition. Proposal: use pod anti-affinity configuration to spread data nodes on different cluster nodes. Cluster nodes count has to be equal or more than the replicas number | {} |
| data.priority_class | Priority class of the elasticsearch data node pods | "" |
| data.resources | Pod resource definition for the elasticsearch data nodes | {} |
| data.storage | Size of the persistent volume of an elasticsearch data node | "1Gi" |
| data.storage_class | Storage class of the elasticsearch data node persistence | "" |
| data.tolerarions | Pod tolerations definition for the elasticsearch data nodes | [] |

# Kibana configuration

|  Parameter | Description  | Default  |
|---|---|---|
| kibana.in_cluster | Set to true to provision a kibana instance | true |
| kibana.url | Specifies external kibana URL when "in_cluster" is false | "" |
| kibana.replicas | Number of kibana instances | 1 |
| kibana.extraEnvs | Additional configuration for kibana | - name: "NODE_OPTIONS"<br />  value: "--max-old-space-size=350" |
| kibana.user | Default Kibana user with administrative privileges | "kibana" |
| kibana.password | Password for the default kibana user | "kibana" |
| kibana.developer.user | User for the development tenant in kibana. The developer tenant can create searched and visualizations in the respective tenant space | "developer" |
| kibana.developer.password | Password for the developer user | "developer" |
| kibana.readonly.user | Readonly user in Kibana | "viewer" |
| kibana.readonly.password | Password for the readonly user | "viewer" |
| kibana.ingress.enabled | When enabled exposes kibana endpoint as an ingress | false |
| kibana.ingress.path | Default context path for the ingress | "/" |
| kibana.ingress.annotations | Any additional ingress controller specific annotations | {} |
| kibana.ingress.tls | TLS ingress configuration | {} |
| kibana.index_patterns | Default set of kibana index patterns | ["containers", "systemd", "nginx"] |
| kibana.tenants | Preconfigured kibana tenants | ["Global", "Developer"] |
| kibana.affinity | Kibana pod affinity definition | {} |
| kibana.priority_class | Kibana pod priority class | "" |
| kibana.resources | Kibana pod resource definition | {} |
| kibana.tolerarions | Kibana pod tolerations definition | [] |


# Fluent-bit configuration

|  Parameter | Description  | Default  |
|---|---|---|
| fluentbit.image | Fluentbit image registry | "fluent/fluent-bit" |
| fluentbit.imageTag | Fluentbit image tag  | "1.7.9" |
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
| fluentd.image | Fluentd image registry | "fluent/fluentd-kubernetes-daemonset" |
| fluentd.imageTag | Fluentd image tag | "v1.12-debian-kafka-1" |
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
| zookeeper.replicas | Replicas of zookeeper statefulset | 1 |
| zookeeper.heap_size | JVM Heap size of a zookeeper node | "128m" |
| zookeeper.affinity | Zookeeper pod affinity definition. Proposal: use pod anti-affinity configuration to spread the zookeeper nodes on different cluster nodes. Cluster nodes count has to be equal or more than the replicas number | {} |
| zookeeper.priority_class | Zookeeper pod priority class | "" |
| zookeeper.resources | Zookeeper pod resource definition | {} |
| zookeeper.storage | Zookeeper pod persistent storage size | "1Gi" |
| zookeeper.storage_class | Storage class of the persistence volume | "1Gi" |
| zookeeper.tolerarions | Zookeeper pod tolerations definition | [] |

Example configuration:
 1. [single node setup](https://github.com/nickytd/kubernetes-logging-helm/blob/747b8ba3e1504b34615bda85448bbb8e3e6c57d7/examples/single-node-setup.yaml)
 2. [multi node ha setup](https://github.com/nickytd/kubernetes-logging-helm/blob/747b8ba3e1504b34615bda85448bbb8e3e6c57d7/examples/multi-node-ha-setup.yaml)
