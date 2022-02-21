Kubernetes Logging stack helm chart parameters

# Global values
  Parameter | Description  | Default  |
|---|---|---|
| cluster_name | opensearch cluster name  | "logging"  |
| imagePullSecrets | Array of secrets for private docker repositories | [] |
| storageClass | Default storage class for the persistent volumes. Each workload can overwrite the default value| "default" |
| priorityClass | Default workloads priority class. Each workload can overwrite the default value | "logging" |

# opensearch nodes parameters

|  Parameter | Description  | Default  |
|---|---|---|
| opensearch.singleNode | Set to true to use single all purpose elastic node. Coordination, data and maser node(s) are provisioned when "singleNode" is set to false | false  |
| opensearch.inCluster |  Set to true to provision an opensearch cluster. When false, an Opensearch url is required  | true  |
| opensearch.image | Opensearch image registry | "opensearchproject/opensearch" |
| opensearch.imageTag | Opensearch image tag | "1.2.0" |
| opensearch.imagePullPolicy | Sets container image pull policy | "IfNotPresent" |
| opensearch.saml.enabled | Set to true to enable SAML for opendistro | false |
| opensearch.saml.idp.metadataUrl | SAML metadata URL | "" |
| opensearch.saml.idp.entityId | SAML Identity Providfer entity id | "" |
| opensearch.saml.idp.cacerts | SAML Identity Providfer CA certificate | "" |
| opensearch.saml.sp.entityId | SAML Service Provider entity id | "" |
| opensearch.saml.exchangeKey | SAML exchange key | "" |
| opensearch.saml.adminRole | SAML role mapped to an opensearch administrator role| "" |
| opensearch.saml.viewerRole | SAML role mapped to an opensearch viewer role | "" |
| opensearch.saml.developerRole | SAML role mapped to an opensearch developer role | "" |
| opensearch.oidc.enabled | Set to true to enable OpenID for opendistro | false |
| opensearch.oidc.discoveryUrl | OpenID well known configuration URL | "" |
| opensearch.oidc.logout_url | OpenID logout URL | "" |
| opensearch.oidc.subjectKey | OpenID subject key | "email" |
| opensearch.oidc.rolesKey | OpenID roles key | "roles" |
| opensearch.oidc.scope | OpenID scope | "openid" |
| opensearch.oidc.adminRole | OpenID role mapped to an opensearch administrator role| "" |
| opensearch.oidc.viewerRole | OpenID role mapped to an opensearch viewer role | "" |
| opensearch.oidc.developerRole | OpenID role mapped to an opensearch developer role | "" |
| opensearch.oidc.cacerts | OpenID Identity Provider CA certificate | "" |
| opensearch.oidc.clientId | OpenID Identity Provider Client ID | "" |
| opensearch.oidc.clientSecret | OpenID Identity Provider Client secret | "" |
| opensearch.oidc.verifyHostnames | OpenID Identity Provider hostname verification | true |
| opensearch.url | External Opensearch url. Required when "inCluster" is set to false | "" |
| opensearch.retentionDays | Opensearch index retention days. Older than the defined retention days indices are removed on a daily basis.  | 7 |
| opensearch.port | Default opensearch port | 9200 |
| opensearch.user | Default opensearch user with administrative privileges   | "osadmin" |
| opensearch.password | Password for the default opensearch user   | "osadmin" |
| opensearch.additionalJvmParams | Additional JVM parameters | "-Djava.net.preferIPv4Stack=true -XshowSettings:properties -XshowSettings:vm -XshowSettings:system" |
| opensearch.snapshot.enabled | Seto to true to enable opensearch snapshots | false |
| opensearch.snapshot.storageClass | The storage class for the snapshot volume. It needs to be a NFS share in a multi node setup. All nodes require access to the same share to be able to generate a snapshot | false |
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
| master.heapSize | JVM Heap size of an opensearch master node. The parameter value is set with jvm -Xmx setting. When pod resource limit is also defined, allow it to reflect the multiple pool sizes of the jvm. | "256m" |
| master.affinity | Pod affinity definition for the opensearch master nodes. Proposal: use pod anti-affinity configuration to spread master nodes on different cluster nodes | {} |
| master.priorityClass | Priority class of the opensearch master node pods | "" |
| master.storage | Size of the persistent volume of an opensearch master node | "1Gi" |
| master.storageClass | Storage class of the opensearch master node persistence | "" |
| master.resources | Pod resource definition for the opensearch master nodes | {}  |
| master.tolerarions | opensearch master nodes pod affinity definition. Proposal: use pod anti-affinity configuration to spread master nodes on different cluster nodes. Cluster nodes count has to be equal or more than the replicas number | [] |

# Opensearch coordination node configuration

|  Parameter | Description  | Default  |
|---|---|---|
| client.replicas | Number of opensearch coordination nodes | 1 |
| client.heapSize | JVM Heap size of an opensearch coordination node | "512m" |
| client.ingress.enabled | Set to true to exposes opensearch http(s) endpoint as an ingress | false |
| client.ingress.path | Default context path for the ingress | "/" |
| client.ingress.annotations | Any additional ingress controller specific annotations | {} |
| client.ingress.tls | TLS ingress configuration | {} |
| client.affinity | Pod affinity definition for the opensearch coordination nodes  | {} |
| client.priorityClass | Priority class of the opensearch coordination node pods | "" |
| client.resources | Pod resource definition for the opensearch coordination nodes | {} |
| client.tolerarions | Pod tolerations definition for the opensearch coordination nodes | [] |
| client.topologySpreadConstraints | opensearch coordination nodes scheduling spread configuration. If possible the workload can be evenly distributed among cluster nodes | {} |

# Opensearch Data node configuration

|  Parameter | Description  | Default  |
|---|---|---|
| data.replicas | Number of opensearch data nodes | 1 |
| data.heapSize | JVM Heap size of an opensearch data node | "512m" |
| data.affinity | opensearch data nodes pod affinity definition. Proposal: use pod anti-affinity configuration to spread data nodes on different cluster nodes. Cluster nodes count has to be equal or more than the replicas number | {} |
| data.priorityClass | Priority class of the opensearch data node pods | "" |
| data.resources | Pod resource definition for the opensearch data nodes | {} |
| data.storage | Size of the persistent volume of an opensearch data node | "1Gi" |
| data.storageClass | Storage class of the opensearch data node persistence | "" |
| data.tolerarions | Pod tolerations definition for the opensearch data nodes | [] |

# Opensearch Data Prepper configuration

|  Parameter | Description  | Default  |
|---|---|---|
| data_prepper.enabled | Set to true to enable Opensearch [Data Prepper](https://opensearch.org/docs/latest/monitoring-plugins/trace/data-prepper/) | false |
| data_prepper.image | Opensearch Data prepper image registry | "opensearchproject/data-prepper" |
| data_prepper.imageTag | Opensearch Data prepper image tag  | "1.1.0" |
| data_prepper.replicas | Number of opensearch data prepper pods | 1 |
| data_prepper.affinity | opensearch data prepper pods affinity definition | {} |
| data_prepper.priorityClass | Priority class of the opensearch data prepper pods | "" |
| data_prepper.resources | Pod resource definition for the opensearch data prepper pods | {} |
| data_prepper.tolerarions | Pod tolerations definition for the opensearch data prepper pods | [] |
| data_prepper.topologySpreadConstraints | opensearch data prepper pods scheduling spread configuration. If possible the workload can be evenly distributed among cluster nodes | {} |

# opensearch-dashboards configuration

|  Parameter | Description  | Default  |
|---|---|---|
| opensearch_dashboards.image | opensearch-dashboards image registry | "opensearchproject/opensearch-dashboards" |
| opensearch_dashboards.imageTag | opensearch-dashboards image tag | "1.2.0" |
| opensearch_dashboards.inCluster | Set to true to provision a opensearch-dashboards instance | true |
| opensearch_dashboards.url | Specifies external opensearch-dashboards URL when "inCluster" is false | "" |
| opensearch_dashboards.replicas | Number of opensearch-dashboards instances | 1 |
| opensearch_dashboards.extraEnvs | Additional configuration for opensearch-dashboards | - name: "NODE_OPTIONS"<br />  value: "--max-old-space-size=350" |
| opensearch_dashboards.user | Default opensearch-dashboards user with administrative privileges | "opensearch-dashboards" |
| opensearch_dashboards.password | Password for the default opensearch-dashboards user | "opensearch-dashboards" |
| opensearch_dashboards.developer.user | User for the development tenant in opensearch-dashboards. The developer tenant can create searched and visualizations in the respective tenant space | "developer" |
| opensearch_dashboards.developer.password | Password for the developer user | "developer" |
| opensearch_dashboards.readonly.user | Readonly user in opensearch-dashboards | "viewer" |
| opensearch_dashboards.readonly.password | Password for the readonly user | "viewer" |
| opensearch_dashboards.ingress.enabled | When enabled exposes opensearch-dashboards endpoint as an ingress | false |
| opensearch_dashboards.ingress.host | Single hostname | "" |
| opensearch_dashboards.ingress.hosts | Reference multiple hostnames  | {} |
| opensearch_dashboards.ingress.path | Default context path for the ingress | "/" |
| opensearch_dashboards.ingress.annotations | Any additional ingress controller specific annotations | {} |
| opensearch_dashboards.ingress.tls | TLS ingress configuration | {} |
| opensearch_dashboards.indexPatterns | Default set of opensearch-dashboards index patterns | ["containers", "systemd", "nginx"] |
| opensearch_dashboards.tenants | Preconfigured opensearch-dashboards tenants | ["Global", "Developer"] |
| opensearch_dashboards.affinity | opensearch-dashboards pod affinity definition | {} |
| opensearch_dashboards.priorityClass | opensearch-dashboards pod priority class | "" |
| opensearch_dashboards.resources | opensearch-dashboards pod resource definition | {} |
| opensearch_dashboards.tolerarions | opensearch-dashboards pod tolerations definition | [] |


# Fluent-bit configuration

|  Parameter | Description  | Default  |
|---|---|---|
| fluentbit.image | Fluentbit image registry | "fluent/fluent-bit" |
| fluentbit.imageTag | Fluentbit image tag  | "1.8.9" |
| fluentbit.imagePullPolicy | Sets container image pull policy | "IfNotPresent" |
| fluentbit.containersLogsHostPath | Path location of the containers logs on the cluster nodes | "/var/log" |
| fluentbit.journalsLogsHostPath | Path location of the systemd logs on the cluster nodes. On minikube change to "/run/log" | "/var/log" |
| fluentbit.affinity | Fluentbit pod affinity definition | {} |
| fluentbit.extraEnvs | Additional configuration for fluentbit | "" |
| fluentbit.priorityClass | Fluentbit pod priority class | "" |
| fluentbit.resources | Fluentbit pod resource definition | {} |
| fluentbit.tolerarions | Fluentbit pod tolerations definition. All tainted nodes needs to be reflected in the tolerations array | [] |
| fluentbit.metrics.enabled | Set to true to enable Prometheus metrics. Requires Prometheus Operator | false |
| fluentbit.metrics.interval | Metrics scrape interval | "30s" |
| fluentbit.metrics.namespace | Namespace where servicemonitor is created | "" | 


# Logstash configuration.
Opensearch [Logstash](https://opensearch.org/docs/latest/clients/logstash/index/) features a dedicated output plugin for opensearch
|  Parameter | Description  | Default  |
|---|---|---|
| logstash.enabled | Set to false to disable logstash logs processing engine | true |
| logstash.image | Logstash image registry | "opensearchproject/logstash-oss-with-opensearch-output-plugin" |
| logstash.imageTag | Fluentd image tag | "7.16.2 |
| logstash.replicas | Number of logstash instances | 1 |
| logstash.heapSize | JVM Heap size of an opensearch logstash instance | "256M" |
| logstash.affinity | Logstash pod affinity definition | {} |
| logstash.priorityClass | Fluentd pod priority class | "" |
| logstash.resources | Fluentd pod resource definition | {} |
| logstash.tolerarions | Fluentd pod tolerations definition | [] |
| logstash.topologySpreadConstraints | Fluentd scheduling spread configuration. If possible the workload can be evenly distributed among cluster nodes | {} |

# Fluentd configuration. 
Fluentd is supplied only when kafka.enabled is set to true.

|  Parameter | Description  | Default  |
|---|---|---|
| fluentd.enabled | Set to true to provision a fluentd instance. Disable logstash to avoid running multiple logs processing engines. | false |
| fluentd.image | Fluentd image registry | "nickytd/fluentd" |
| fluentd.imageTag | Fluentd image tag | "v1.13" |
| fluentd.imagePullPolicy | Sets container image pull policy | "IfNotPresent" |
| fluentd.replicas | Number of fluentd instances | 1 |
| fluentd.affinity | Fluentd pod affinity definition | {} |
| fluentd.extraEnvs | Additional configuration for fluentd | "" |
| fluentd.priorityClass | Fluentd pod priority class | "" |
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
| kafka.heapSize | JVM Heap size of a kafka broker | "256m" |
| kafka.topics | Kafka broker topic configuration | config:<br /> "retention.bytes=134217728,retention.ms=3600000,message.timestamp.difference.max.ms=3600000,message.timestamp.type=LogAppendTime"<br /> name: ["containers"] |
| kafka.affinity | Kafka pod affinity definition. Proposal: use pod anti-affinity configuration to spread the kafka brokers on different cluster nodes. Cluster nodes count has to be equal or more than the replicas number | {} |
| kafka.priorityClass | Kafka pod priority class | "" |
| kafka.resources | Kafka pod resource definition | {} |
| kafka.storage | Kafka broker persistent storage size | "1Gi" |
| kafka.storageClass | Storage class of the persistence volume | "1Gi" |
| kafka.tolerarions | Kafka pod tolerations definition | [] |


#Zookeeper is a dependency of kafka

|  Parameter | Description  | Default  |
|---|---|---|
| zookeeper.image | Image repository of the zookeeper container image | "zookeeper" |
| zookeeper.imageTag | Image tag of zookeeper container image | "3.7.0" |
| zookeeper.imagePullPolicy | Sets container image pull policy | "IfNotPresent" |
| zookeeper.replicas | Replicas of zookeeper statefulset | 1 |
| zookeeper.heapSize | JVM Heap size of a zookeeper node | "128m" |
| zookeeper.affinity | Zookeeper pod affinity definition. Proposal: use pod anti-affinity configuration to spread the zookeeper nodes on different cluster nodes. Cluster nodes count has to be equal or more than the replicas number | {} |
| zookeeper.priorityClass | Zookeeper pod priority class | "" |
| zookeeper.resources | Zookeeper pod resource definition | {} |
| zookeeper.storage | Zookeeper pod persistent storage size | "1Gi" |
| zookeeper.storageClass | Storage class of the persistence volume | "1Gi" |
| zookeeper.tolerarions | Zookeeper pod tolerations definition | [] |

Example configuration:
 1. [single node setup](https://github.com/nickytd/kubernetes-logging-helm/blob/ddc174e6fef71e375f1e27fa3ce5188a2831aeb5/examples/single-node-setup.yaml)
 2. [multi node ha setup](https://github.com/nickytd/kubernetes-logging-helm/blob/ddc174e6fef71e375f1e27fa3ce5188a2831aeb5/examples/multi-node-ha-setup.yaml)
