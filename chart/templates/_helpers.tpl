{{/*
Expand the name of the chart.
*/}}
{{- define "logging.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "logging.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "logging.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create default labels section
*/}}
{{- define "logging.labels" }}
{{- include "logging.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/opensearch: {{ .Values.opensearch.imageTag }}
{{- end }}

{{/*
Create default labels section
*/}}
{{- define "logging.selectorLabels" }}
app.kubernetes.io/name: {{ include "logging.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "init_container.image" -}}
{{- $image := .Values.init_container.image -}}
{{- $imageTag := .Values.init_container.imageTag -}}
{{- printf "%s:%s" $image $imageTag -}}
{{- end -}}

{{- define "os_url" -}}
{{- if .Values.opensearch.externalOpensearch.disabled -}}
{{ printf "https://%s-client.%s.%s:9200" .Release.Name .Release.Namespace "svc.cluster.local" }}
{{- else -}}
{{- printf "%s" .Values.opensearch.externalOpensearch.url -}}
{{- end -}}
{{- end -}}

{{- define "os_host" -}}
{{- if .Values.opensearch.externalOpensearch.disabled -}}
{{ printf "%s-client.%s.%s" .Release.Name .Release.Namespace "svc.cluster.local" }}
{{- else -}}
{{- $url := urlParse .Values.opensearch.externalOpensearch.url }}
{{- $host := last (regexSplit ":" $url.host 1) }}
{{- printf "%s" $host -}}
{{- end -}}
{{- end -}}

{{- define "os_port" -}}
{{- if .Values.opensearch.externalOpensearch.disabled -}}
{{ printf "%d" 9200 }}
{{- else -}}
{{- $url := urlParse .Values.opensearch.externalOpensearch.url }}
{{- $port := last (regexSplit ":" $url.host -1) | int }}
{{- if and ( eq $port 0 ) ( eq $url.scheme "http" ) }}
{{- printf "%d" 80 }}
{{- else if and ( eq $port 0 ) ( eq $url.scheme "https" ) }}
{{- printf "%d" 443 }}
{{- else -}}
{{- printf "%d" $port -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "opensearch-dashboards_url" -}}
{{- if $.Values.opensearch_dashboards.externalOpensearchDashboards.disabled -}}
{{ printf "http://%s-opensearch-dashboards.%s.svc.cluster.local:5601" .Release.Name .Release.Namespace }}
{{- else -}}
{{- printf "%s" .Values.opensearch_dashboards.externalOpensearchDashboards.url -}}
{{- end -}}
{{- end -}}

{{/*
https://github.com/openstack/openstack-helm-infra/blob/master/helm-toolkit/templates/utils/_joinListWithComma.tpl
*/}}
{{- define "helm-toolkit.utils.joinListWithComma" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}},{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}

{{- define "kafkaBrokers" -}}
{{- $rn := .releaseName -}}
{{- $kafka := dict "servers" (list) -}}
{{- range int .replicas | until -}}
{{- $noop := printf "%s-kafka-%d:9092" $rn . | append $kafka.servers | set $kafka "servers" -}}
{{- end -}}
{{- join "," $kafka.servers -}}
{{- end -}}

{{- define "kafkaQuorum" -}}
{{- $rn := .releaseName -}}
{{- $kafka := dict "servers" (list) -}}
{{- range int .replicas | until -}}
{{- $noop := printf "%d@%s-kafka-%d:9093" . $rn . | append $kafka.servers | set $kafka "servers" -}}
{{- end -}}
{{- join "," $kafka.servers -}}
{{- end -}}

{{/*
Get certificates secret name
*/}}
{{- define "getSecretName" -}}
{{- $res := printf "%s-%s" .namespace .name -}}
{{- $res -}}
{{- end -}}
