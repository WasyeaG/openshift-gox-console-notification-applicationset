# OpenShift Authentication Design

## Overview

The reusable GitHub Actions workflow authenticates to OpenShift using GitHub encrypted repository secrets. Authentication is performed at workflow runtime and no credentials are stored in source control.

---

## Credential Storage

Environment-specific credentials are stored as GitHub Actions repository secrets.

Typical secrets include:

- GOX_SBX_SERVER
- GOX_SBX_TOKEN
- GOX_STG_SERVER
- GOX_STG_TOKEN
- GOX_PRD_SERVER
- GOX_PRD_TOKEN

---

## Credential Protection

GitHub repository secrets provide the following protections:

- Secret values are encrypted by GitHub.
- Secret values are masked in workflow logs.
- Secrets are not committed to Git.
- Secrets are only available during workflow execution.
- Repository access controls limit who can manage or update secrets.

---

## Workflow Authentication

During workflow execution:

1. GitHub Actions retrieves the required secrets.
2. The workflow authenticates to the target OpenShift cluster.
3. The rendered ApplicationSet is applied.
4. No credentials are written to repository files or workflow artifacts.

---

## Security Summary

This authentication approach ensures:

- Credentials remain outside source control.
- Environment-specific authentication is isolated through repository secrets.
- Authentication is performed only during workflow execution.
