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
- The generated Argo CD Application uses `targetRevision: sbx`.
- The application reached:
  - **Sync Status:** Synced
  - **Health Status:** Healthy.

---

## Promotion Strategy

Changes progress through environments using pull requests.

```text
Feature Branch
      |
      v
 Pull Request
      |
      v
    sbx
      |
 Validation
      v
 Pull Request
      |
      v
    stg
      |
 Validation
      v
 Pull Request
      |
      v
    main
```

The intended promotion path is:

```text
sbx -> stg -> main
```

Changes should be validated in each lower environment before promotion to the next environment.

---

## Rollback Strategy

Rollback is performed through Git rather than by modifying resources manually in the cluster.

Recommended rollback process:

1. Identify the last known-good commit for the affected environment branch.
2. Revert the faulty commit or merged pull request.
3. Merge or push the revert commit to the affected environment branch.
4. Allow the deployment workflow and Argo CD to reconcile the previous state.
5. Verify that the Argo CD Application returns to **Synced** and **Healthy**.

For urgent recovery, the environment branch can be reset to a previously validated commit, but a revert commit is preferred because it preserves the audit history.

---

## Auditability

The branch-based model provides deployment traceability through:

- Git commit history
- Pull request and approval history
- GitHub Actions workflow runs
- Rendered ApplicationSet artifacts
- Argo CD synchronization history
- The commit associated with each environment branch

Because branches are mutable, the deployed commit SHA should be recorded in workflow output or deployment evidence.

---

## Risks and Operational Trade-offs

### Branch Drift

Long-lived environment branches can diverge, causing environments to contain different changes beyond their intended promotion level.

**Mitigation**

- Promote changes in order: `sbx` → `stg` → `main`
- Use pull requests for every promotion.
- Regularly compare environment branches.
- Prevent direct commits to protected branches.

### Merge Conflicts

Delayed promotions can result in merge conflicts between environment branches.

**Mitigation**

- Promote small changes frequently.
- Keep branch history linear where practical.
- Resolve conflicts through reviewed pull requests.

### Mutable References

Git branches are mutable references.

**Impact**

A branch name alone is insufficient to identify the exact deployed version.

**Mitigation**

- Record the resolved commit SHA in deployment logs.
- Use immutable tags or commit SHAs for production releases when stronger controls are required.

### Workflow Dependency on `main`

The caller workflow references the reusable workflow using `@main`.

**Risk**

A change to the reusable workflow can affect all environments without updating the caller repository.

**Mitigation**

- Pin the reusable workflow to a release tag or commit SHA.
- Test reusable workflow changes before updating the pinned reference.

### Human Error

Direct commits or incorrect merges can bypass the intended promotion process.

**Mitigation**

- Enable branch protection.
- Require pull request reviews.
- Require successful CI validation.
- Restrict force pushes.

### Credential Exposure

Environment-specific OpenShift tokens are used for deployment.

**Mitigation**

- Use dedicated service accounts.
- Grant least-privilege RBAC.
- Rotate credentials regularly.
- Store credentials only in GitHub Secrets.

---

## Prototype Limitations

The current prototype has the following limitations:

- Only the `gox-sbx` deployment has been validated end-to-end.
- Staging and production-like environments have only been rendered.
- Promotion between branches remains manual.
- Rollback is a documented Git process.
- Reusable workflows are referenced using the mutable `main` branch.
- Workflow output does not currently report the resolved application commit SHA.
- Push-triggered runs perform render-only validation.
- Deployment requires an explicit workflow dispatch with `dry_run=false`.
- OpenShift authentication currently skips TLS certificate verification.
- No approval gate exists for production-like deployment.

---

## Proposed Improvements

Future enhancements include:

- Validate the deployment flow for `gox-stg` and `gox-prd`.
- Configure GitHub branch protection.
- Use GitHub Environments with deployment approvals.
- Pin reusable workflows to immutable release tags or commit SHAs.
- Report the resolved application commit SHA in workflow summaries.
- Add automated promotion validation.
- Add automated rollback workflows.
- Replace long-lived tokens with short-lived authentication where possible.
- Configure trusted OpenShift certificate authorities.
- Evaluate a tag-based deployment model for production.

---

## Conclusion

The prototype demonstrates that Argo CD can successfully deploy the Console Notification workload using environment-specific Git branches as the `targetRevision`.

The sandbox deployment successfully tracks the `sbx` branch and is currently **Synced** and **Healthy**. This prototype provides a solid foundation for evaluating branch-based GitOps promotion while identifying improvements that would be appropriate before adopting the model for production environments.
