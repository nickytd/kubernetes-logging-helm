{{/* vim: set filetype=mustache: */}}
{{/*Expand the name of the chart.*/}}
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

{{/*Create chart name and version as used by the chart label.*/}}
{{- define "logging.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*Create default labels section*/}}
{{- define "logging.labels" }}
{{ include "logging.selectorLabels" . }}
{{- if .Chart.Version }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/elastic: {{ .Values.elasticsearch.imageTag  }}
app.kubernetes.io/openDistro: {{ .Values.opendistro.imageTag }}
{{- end }}

{{/*Create default labels section*/}}
{{- define "logging.selectorLabels" }}
app.kubernetes.io/name: {{ include "logging.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*Create zookeeper server str*/}}
{{- define "zookeeper_servers" -}}
{{- $zk_size := default 1 .Values.zookeeper.replicas | int -}}
{{- $global := . -}}
{{- $str := "" -}}

{{- range $i, $e := until $zk_size -}}
{{- $str := (printf "server.%d=%s-zk-%d.zk.%s.svc.cluster.local:2888:3888;2181 " $i $global.Release.Name $i $global.Release.Namespace) -}}
{{- $str -}}
{{- end -}}
{{- end -}}


{{- define "init_container.image" -}}
{{- $image := .Values.init_container_image.image -}}
{{- $imageTag := .Values.init_container_image.imageTag -}}
{{- printf "%s:%s" $image $imageTag -}}
{{- end -}}

{{- define "esurl" -}}
{{- if .Values.elasticsearch.in_cluster -}}
{{ printf "https://%s-client.%s.%s:9200" .Release.Name .Release.Namespace "svc.cluster.local" }}
{{- else -}}
{{- printf "%s" .Values.elasticsearch.url -}}
{{- end -}}
{{- end -}}
