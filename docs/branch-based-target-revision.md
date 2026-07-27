# Branch-Based GitOps Target Revision Prototype

## Overview

This document describes the branch-based GitOps delivery prototype implemented for the Console Notification ApplicationSet.

The objective of this prototype is to evaluate using Git branches as the Argo CD `targetRevision` for environment-specific deployments while documenting the promotion strategy, rollback process, operational considerations, and associated trade-offs.

---

## Branch-to-Environment Mapping

| Git Branch | Environment | OpenShift Cluster | Argo CD targetRevision |
|------------|-------------|-------------------|------------------------|
| `sbx` | Sandbox | `gox-sbx` | `sbx` |
| `stg` | Staging | `gox-stg` | `stg` |
| `main` | Production-like | `gox-prd` | `main` |

Each environment overrides the default `targetRevision` through its environment-specific values file.

---

## Prototype Validation

The prototype was validated by deploying the Console Notification ApplicationSet to the sandbox environment.

Validation confirmed:

- GitHub Actions successfully rendered the ApplicationSet.
- The ApplicationSet was deployed to OpenShift.
- The generated Argo CD Application uses:
  - `targetRevision: sbx`
- The application reached:
  - **Sync Status:** Synced
  - **Health Status:** Healthy

---

## Promotion Strategy

Changes progress through environments using pull requests.

```text
Feature Branch
      │
      ▼
 Pull Request
      │
      ▼
    sbx
      │
 Validation
      ▼
 Pull Request
      │
      ▼
    stg
      │
 Validation
      ▼
 Pull Request
      │
      ▼
    main
eof

