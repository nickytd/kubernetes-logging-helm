[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/kubernetes-logging-helm)](https://artifacthub.io/packages/search?repo=kubernetes-logging-helm)
# kubernetes-logging-helm

This helm chart deploys a Kubernetes logging stack with the main purpose of enabling log observability for applications. The design supports both local development use cases such as minikube deployments up to a scaled up production scenarios. The latter scenario leverages kafka message broker completely decoupling the log generations and indexing functions. 

The helm chart deploys elastic in various configurations from single node setup for local development to a scaled multi nodes elastic deployment. In the latter case there are 3 types of nodes (coordination, data and master) where each of those can be horizontally scaled depending on the load and shards replication demands. 

Finally the helm chart provides index templates management in elastic and index pattern management in kibana. An initial predefined set of dashboards is also provided for illustration purposes.

![Kubernetes Logging Stack](images/k8s-logging-stack.jpg)

Here is a [setup example](https://github.com/nickytd/kubernetes-logging-helm/tree/master/examples) for local development and testing based on [minikube](https://minikube.sigs.k8s.io)

Here is a [single node setup](https://github.com/nickytd/kubernetes-logging-helm/tree/master/examples/k8s-logging-minikube-values.yaml)

Provisioned components:
 1. Single Elastic node
 1. Fluent-Bit instance per kubernetes node
 1. (optional elastic-exporter)


And a [scaled out multi node setup](https://github.com/nickytd/kubernetes-logging-helm/tree/master/examples/k8s-logging-scaled-minikube-values.yaml)

Provisioned components:
 1. 2 Elastic coordination nodes
 1. 2 Elastic master nodes
 1. 2 Elastic data nodes
 1. Fluent-Bit instance per kubernetes node
 1. 2 Kafka brokers
 1. Zookeeper
 1. FluentD
 1. (optional elastic-exporter)

Following dashboards in Kibana are also provisioned for illustration purposes

Logs Stream Dashboard 
![Logs Stream Dashboard](images/containers-dashboard.png)

Systemd logs Dashboard
![Systemd logs Dashboard](images/systemd-dashboard.png)

Nginx Access Logs Dashboard
![Nginx Access Logs Dashboard](images/nginx-dashboard.png)

Multi tenant layout is also supported in Kibana. This helm chart sets up a Developer tenant with the corresponding role having read/write permission in the corresponding tenant space.
