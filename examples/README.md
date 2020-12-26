# Example
Here is a sample setup of the kubernetes logging stack with a scaled down configuration for [kind](https://kind.sigs.k8s.io).
It can be used for experimenting and development purposes. 

Default username and passwords are defined in the chart [configuration file](https://github.com/nickytd/k8s-logging-helm/blob/master/values.yaml)

The default chart configuration supports minikube based clusters.
In other case,s the filebeats and journalbeats configurations have to be adjusted in accordance to the concrete node types forming the cluster.
The locations of journal logs or container logs may differ from one platform to anoter.


Ubuntu | Kind | Minikube
--- | --- | ---
/var/log/journal | /run/log/journal | /var/run/log/journal
/var/log/containers | /var/log/pods | /var/lib/docker/containers


In addition the file path format of the container logs differs as well.
Filebeat [kubernetes metadata](https://www.elastic.co/guide/en/beats/filebeat/current/add-kubernetes-metadata.html) processor distingueshed between ```container```and ```pod```resource types.

For example, in Ubuntu based nodes we can have filebeat configuration supporting kubernetes metadata:
```
   processors:
      - add_id: ~
      - add_kubernetes_metadata:
          in_cluster: true
          default_indexers.enabled: false
          default_matchers.enabled: false
          indexers:
            - container:
          matchers:
            - logs_path:
                logs_path: '/var/log/containers'
                resource_type: containers
      - drop_fields:
          fields: ["kubernetes.metadata.managedFields","container"]
          ignore_missing: false              
            
    filebeat.autodiscover:
      providers:
        - type: kubernetes
          templates:
            - condition:
                has_fields: ['kubernetes.pod.uid']
              config:
                - type: container 
                  paths:
                    - /var/log/containers/${data.kubernetes.container.id}/*.log                   
                  multiline.pattern: '^}|^[[:space:]]+|^[[:cntrl:]][[:graph:]]([[:digit:]]+)[m|K]([[:space:]]+)'
                  multiline.negate: false
                  multiline.match: after
                  multiline.max_lines: 200
```

And in the case of Kind provisioned cluster the same goal can be achieved with:
```
processors:
      - add_id: ~
      - add_kubernetes_metadata:
          in_cluster: true
          default_indexers.enabled: false
          default_matchers.enabled: false
          indexers:
            - container:
          matchers:
            - logs_path:
                logs_path: '/var/log/pods'
                resource_type: pod
      - drop_fields:
          fields: ["kubernetes.metadata.managedFields","container"]
          ignore_missing: false              
            
    filebeat.autodiscover:
      providers:
        - type: kubernetes
          templates:
            - condition:
                has_fields: ['kubernetes.pod.uid']
              config:
                - type: container 
                  paths:
                    - /var/log/pods/${data.kubernetes.namespace}_${data.kubernetes.pod.name}_${data.kubernetes.pod.uid}/${data.kubernetes.container.name}/*.log
                  multiline.pattern: '^}|^[[:space:]]+|^[[:cntrl:]][[:graph:]]([[:digit:]]+)[m|K]([[:space:]]+)'
                  multiline.negate: false
                  multiline.match: after
                  multiline.max_lines: 200
```

