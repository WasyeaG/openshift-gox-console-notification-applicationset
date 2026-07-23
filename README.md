# OpenShift GOX ConsoleNotification ApplicationSet

This repository contains a Helm chart that deploys an Argo CD ApplicationSet.

The ApplicationSet automatically generates an Argo CD Application for every
cluster matching the configured label selector and deploys the
ConsoleNotification Helm chart.

## Repository Structure

charts/
└── console-notification-applicationset/
    ├── Chart.yaml
    ├── values.yaml
    ├── values-sbx.yaml
    └── templates/
        ├── _helpers.tpl
        └── applicationset.yaml

## Architecture

Helm
  ↓
ApplicationSet
  ↓
Application
  ↓
ConsoleNotification Helm Chart
  ↓
OpenShift ConsoleNotification

## Prerequisites

- OpenShift GitOps installed
- ApplicationSet CRD available
- Argo CD cluster registration
- Helm 3
- OpenShift CLI

## Validation

helm lint charts/console-notification-applicationset

helm template gox-sbx-console-notification-applicationset \
charts/console-notification-applicationset \
-f charts/console-notification-applicationset/values-sbx.yaml

## Manual Deployment

helm upgrade --install gox-sbx-console-notification-applicationset \
charts/console-notification-applicationset \
--namespace openshift-gitops \
-f charts/console-notification-applicationset/values-sbx.yaml

## Verification

helm status gox-sbx-console-notification-applicationset \
-n openshift-gitops

oc get applicationset -n openshift-gitops

oc get application -n openshift-gitops

oc get consolenotification

## Design

- Helm manages the ApplicationSet.
- ApplicationSet generates Applications dynamically.
- Applications deploy the ConsoleNotification Helm chart.
- Cluster selection is label based.
- Automated Sync, Prune and SelfHeal are enabled.

