{{/*
Expand the name of the chart.
*/}}
{{- define "CloudPakHumioCluster.name" -}}
{{- default .Chart.Name .Values.nameOverride | lower | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "CloudPakHumioCluster.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | lower | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | lower | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | lower | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "CloudPakHumioCluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | lower | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "CloudPakHumioCluster.labels" -}}
helm.sh/chart: {{ include "CloudPakHumioCluster.chart" . }}
meta.helm.sh/release-namespace: {{ .Release.Namespace }}
{{ include "CloudPakHumioCluster.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "CloudPakHumioCluster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "CloudPakHumioCluster.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "CloudPakHumioCluster.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "CloudPakHumioCluster.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Route address
*/}}
{{- define "CloudPakHumioCluster.routeurlreference" -}}
cp-console.{{ "{{" }} .OpenShiftBaseUrl {{ "}}" }}
{{- end }}

{{- define "clientSecret" -}}
CLIENT_SECRET
{{- end }}
