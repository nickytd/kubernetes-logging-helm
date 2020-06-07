# kubernetes-logging-helm

This is a comprehensive helm chart for deploying complete K8S logging stack featuring few desings options suitable from a minikube setup up to a mighty scaled provisioning capable of processing billions of records.

Here is a [minikube setup example](https://github.com/nickytd/k8s-logging-helm/tree/master/examples) for local development and testing

Start a sample provisioning with
[examples/install-es.sh](https://github.com/nickytd/k8s-logging-helm/blob/master/examples/install-es.sh)


Provisioning options:
By default the helm chart setup following components:
 1. Elastic coordination node
 1. Elastic master node
 1. Elastic data node
 *. filebeat
 *. journalbeat
 1. logstash
 1. kibana
 
In this option setup, the beats directly talk to the logstash instance.
 
There are two options to scale the setup:
* For medium logging streams volumes the chart can be horizontaly scaled by increasing the replicas of the Elastic nodes and Logstash deployment.

* For high logging stream volume a kafka broker can be enabled in the chart so the beats( or application pods sidecars) can push logs to the kafka topics. Then the Logstash input is the kafka queues and the output is the dedicated elasticsearch instance. 

The logging stream has dedicated elasticsearch indices. The stdout and stderr from containers are pushed to "containers-<date>" indices. The systemlog of the OS if journabeat is enabled is pushed to "journals-<date>".

The chart also supports extrnal(outside the cluster) elasticsearch instance in which mode no elastic (coordination, data, master) nodes will be provisioned.

Kibana by default comes with 2 predefined dashboards and set of searches
1. Containers logs dashboard, grouping container logs per namespace and pod
![Containers Logs](https://github.com/nickytd/k8s-logging-helm/blob/master/images/ContainerLogsDashboard.png)
2. Journals logs dashboard, grouping systemlogs per system unit and node
![Journals Logs](https://github.com/nickytd/k8s-logging-helm/blob/master/images/JournalsLogsDashboard.png)

