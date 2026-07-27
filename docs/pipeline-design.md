# GOX GitOps Reusable Pipeline Design

## Overview

This repository contains the reusable GitHub Actions workflow used to render and deploy Argo CD ApplicationSets for the GOX GitOps lab. The workflow supports multiple OpenShift environments while maintaining a clean-room implementation independent of existing Li9 pipeline code.

---

## Repository Naming

All repositories created for this lab follow the required naming convention and include the `-gox-` identifier.

Repositories:

- openshift-gox-gitops-workflows
- openshift-gox-console-notification
- openshift-gox-console-notification-applicationset

---

## Branch-to-Environment Mapping

The workflow supports the following branch mapping strategy.

| Git Branch | Target Environment |
|------------|--------------------|
| sbx | Sandbox |
| stg | Staging |
| main | Production-like |

This mapping allows independent promotion between environments while keeping Git as the desired source of truth.

---

## Authentication

GitHub Actions authenticates to each OpenShift cluster using GitHub encrypted repository secrets.

Environment-specific API endpoints and authentication tokens are stored as GitHub Secrets.

Typical secrets include:

- GOX_SBX_SERVER
- GOX_SBX_TOKEN
- GOX_STG_SERVER
- GOX_STG_TOKEN
- GOX_PRD_SERVER
- GOX_PRD_TOKEN

Secrets are never committed to Git, are encrypted by GitHub, and are injected only during workflow execution. Secret values are masked in workflow logs.

---

## Dry-Run Mode

The reusable workflow supports rendering ApplicationSet manifests without applying them to an OpenShift cluster.

When dry-run mode is enabled:

- Helm templates are rendered.
- Rendered manifests are uploaded as workflow artifacts.
- No OpenShift resources are modified.

This capability allows validation before deployment.

---

## Clean-Room Implementation

The reusable GitHub Actions workflow was implemented specifically for the GOX GitOps lab.

Existing Li9 implementations were referenced only for architectural concepts and workflow behavior.

No workflow YAML, reusable workflow implementation, or pipeline code was copied from legacy repositories.

---

## Summary

The reusable pipeline provides:

- Multi-environment deployment support
- Branch-based environment mapping
- Secure GitHub Actions authentication
- Dry-run validation capability
- Clean-room implementation aligned with project requirements
