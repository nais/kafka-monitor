{{- define "kafka_monitor.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kafka_monitor.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if ne $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "kafka_monitor.serviceaccountname" -}}
{{- if .Values.serviceaccount_name -}}
{{- .Values.serviceaccount_name -}}
{{- else -}}
{{- template "kafka_monitor.fullname" . -}}
{{- end -}}
{{- end -}}

