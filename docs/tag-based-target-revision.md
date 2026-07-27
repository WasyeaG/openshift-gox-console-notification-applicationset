# Tag-Based GitOps Target Revision Prototype

## Overview

This prototype evaluates using Git tags as the Argo CD `targetRevision` for environment-specific deployments of the Console Notification application. The objective is to provide immutable deployment references, improve release traceability, and simplify promotion and rollback across environments.

---

## Tag Naming Convention

The following tag naming convention is used:

| Git Tag | Environment | OpenShift Cluster | Argo CD targetRevision |
|----------|-------------|-------------------|------------------------|
| v0.1.0-sbx | Sandbox | gox-sbx | v0.1.0-sbx |
| v0.1.0-stg | Staging | gox-stg | v0.1.0-stg |
| v0.1.0-prd | Production-like | gox-prd | v0.1.0-prd |

Each environment references a specific immutable Git tag through its environment-specific values file.

---

## Deployment Validation

The prototype was validated by deploying the Console Notification ApplicationSet to the sandbox environment.

Validation confirmed:

- Argo CD ApplicationSet renders successfully.
- Generated Argo CD Application uses `targetRevision: v0.1.0-sbx`.
- Application reaches Synced and Healthy status.
- Console Notification deploys successfully to gox-sbx.

---

## Promotion Strategy

Promotion is performed by creating versioned Git tags for each environment.

Example promotion flow:



```
v0.1.0-sbx
      │
      ▼
v0.1.0-stg
      │
      ▼
v0.1.0-prd
```

Each environment deploys the approved tag without changing application source code.

---

## Rollback Strategy

Rollback is performed by updating the ApplicationSet to reference a previously validated Git tag.

Example:

```
Current:
targetRevision: v0.2.0-prd

Rollback:
targetRevision: v0.1.0-prd
```

Since Git tags reference immutable commits, rollback is predictable and repeatable.

---

## Auditability

Using Git tags provides:

- Immutable release references
- Clear deployment history
- Traceability between Git commits and deployed applications
- Easier release auditing

---

## Risks and Trade-Offs

Benefits:

- Immutable deployments
- Improved release traceability
- Predictable rollbacks
- Easier auditing

Risks:

- Additional tag management
- Tag naming consistency must be enforced
- Promotion requires creation and management of release tags

---

## Limitations

This prototype validates the tag-based deployment model only for the gox-sbx environment.

Additional validation across gox-stg and gox-prd would be required before production adoption.

---

## Future Improvements

Potential improvements include:

- Automated tag creation within CI/CD pipelines
- Signed Git tags
- Automated release notes
- Policy-based promotion approvals
- Integration with release management workflows

---

## Conclusion

The prototype demonstrates that Argo CD can successfully deploy the Console Notification application using immutable Git tags as the targetRevision while improving release traceability, auditability, and rollback capabilities.
