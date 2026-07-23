# OpenShift GOX ConsoleNotification ApplicationSet

This repository contains a Helm chart that deploys an **Argo CD ApplicationSet** for the OpenShift **ConsoleNotification** workload.

The ApplicationSet dynamically generates Argo CD Applications for clusters matching the configured label selector and deploys the ConsoleNotification Helm chart using GitOps.

---

## Related Repository

This ApplicationSet deploys the ConsoleNotification Helm chart from:

**https://github.com/WasyeaG/openshift-gox-console-notification**

---

## Repository Structure

```text
charts/
└── console-notification-applicationset/
    ├── Chart.yaml
    ├── values.yaml
    ├── values-sbx.yaml
    └── templates/
        ├── _helpers.tpl
        └── applicationset.yaml
```

---

## Architecture

```text
Helm
  │
  ▼
ApplicationSet
  │
  ▼
Application
  │
  ▼
ConsoleNotification Helm Chart
  │
  ▼
OpenShift ConsoleNotification
```

---

## Prerequisites

- OpenShift GitOps installed
- ApplicationSet CRD available
- Argo CD cluster registration
- Helm 3
- OpenShift CLI

---

## Validate the Chart

```bash
helm lint charts/console-notification-applicationset
```

Render the ApplicationSet:

```bash
helm template gox-sbx-console-notification-applicationset \
  charts/console-notification-applicationset \
  -f charts/console-notification-applicationset/values-sbx.yaml
```

---

## Manual Deployment

```bash
helm upgrade --install gox-sbx-console-notification-applicationset \
  charts/console-notification-applicationset \
  --namespace openshift-gitops \
  -f charts/console-notification-applicationset/values-sbx.yaml
```

---

## Verification

Check the Helm release:

```bash
helm status gox-sbx-console-notification-applicationset \
  -n openshift-gitops
```

Verify the ApplicationSet:

```bash
oc get applicationset -n openshift-gitops
```

Verify the generated Application:

```bash
oc get applications -n openshift-gitops
```

Verify the ConsoleNotification resource:

```bash
oc get consolenotification
```

---

## Design

- Helm manages the ApplicationSet lifecycle.
- The ApplicationSet dynamically generates Argo CD Applications.
- Generated Applications deploy the ConsoleNotification Helm chart.
- Cluster selection is based on labels.
- Automated Sync, Prune, and Self-Heal are enabled.
- Repository URL, chart path, target revision, destination namespace, and values files are configurable.

