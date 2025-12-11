Title: Move `nonprod_subdomains` module from `network` to `global/ops` (Hoopla Non Prod)

This PR completes the refactor of the `nonprod_subdomains` module for the Hoopla non-prod account, following DEVOPS-1350.

# Summary of Work Done

## 1. Moved the module definition

- The nonprod_subdomains module was relocated from: `us-east-1/ops/network` => `global/ops`
- Updated the module call and all relevant provider references accordingly.

## 2. Performed a state migration (terraform state transfer)

To avoid recreating any existing AWS resources, I performed a **state migration**:

- Pulled the existing remote Terraform state.
- Identified all resources under: `module.nonprod_subdomains["*"]`
- **Transferred** these resources from the `network` state to the `global` state.
- Removed the old entries from the `network` state to prevent duplication or drift.

**No resources were created or destroyed during this migration**.
This was strictly a Terraform state move, not an infrastructure change.

## 3. Updated configuration in all dependent locations

- Adjusted the references under `devops/data.tf` and `us-ease-1/ops/data.tf` so that global/ops is now the source of truth for the subdomain information.
- Ensured the module is now fully managed by `global/ops` and no longer by `network`.

## Outcome

- The nonprod_subdomains module is now fully centralized under `global/ops` for the Hoopla non-prod account.
- All associated Route53, ACM certificate, validation, and VPC association resources were successfully migrated without any creation or deletion.
- I also verified that **ecom-nonprod** is currently still calling the nonprod_subdomains module.
After this PR is validated and approved, I will create a follow-up subtask to migrate ecom-nonprod to the new global/ops structure as well.