{{- define "test-urukube-app.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{- define "test-urukube-app.fullname" -}}
{{- if contains (include "test-urukube-app.name" .) .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "test-urukube-app.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "test-urukube-app.labels" -}}
app.kubernetes.io/name: {{ include "test-urukube-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "test-urukube-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "test-urukube-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
