{{/*
Return the ApplicationSet name.
*/}}
{{- define "console-notification-applicationset.name" -}}
{{- required "applicationset.name must be set" .Values.applicationset.name -}}
{{- end }}
