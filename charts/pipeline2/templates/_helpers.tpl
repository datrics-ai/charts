{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pipeline2.app.name" -}}
{{- $defaultName := printf "%s-app" .Chart.Name -}}
{{- default $defaultName .Values.app.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pipeline2.worker.name" -}}
{{- $defaultName := printf "%s-worker" .Chart.Name -}}
{{- default $defaultName .Values.worker.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pipeline2.app.fullname" -}}
{{- if .Values.app.fullnameOverride -}}
{{- .Values.app.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $defaultName := default .Chart.Name .Values.app.nameOverride -}}
{{- $name := printf "%s-app" $defaultName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pipeline2.worker.fullname" -}}
{{- if .Values.worker.fullnameOverride -}}
{{- .Values.worker.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $defaultName := default .Chart.Name .Values.worker.nameOverride -}}
{{- $name := printf "%s-worker" $defaultName -}}
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
{{- define "pipeline2.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "pipeline2.app.labels" -}}
helm.sh/chart: {{ include "pipeline2.chart" . }}
{{ include "pipeline2.app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "pipeline2.worker.labels" -}}
helm.sh/chart: {{ include "pipeline2.chart" . }}
{{ include "pipeline2.worker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "pipeline2.app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pipeline2.app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "pipeline2.worker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pipeline2.worker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "pipeline2.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "pipeline2.app.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
