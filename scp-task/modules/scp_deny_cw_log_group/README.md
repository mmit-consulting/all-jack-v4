# Terraform Module: SCP – Deny CloudWatch Log Group Creation

This module creates and manages an AWS Service Control Policy (SCP) that **blocks the creation of new CloudWatch Log Groups** in selected AWS accounts.  
It is designed for controlled, incremental rollout across multiple accounts (e.g., enabling the SCP for 2 accounts at a time).

---

## Features

- Creates a single reusable SCP: `DenyCloudWatchLogGroupCreation`
- Attaches the SCP only to the accounts you specify
- Does **not** affect Root, OUs, or other accounts unless explicitly listed
- Safe incremental rollout by updating a single variable
- Ensures consistent logging governance across the AWS Organization

---

## Policy Behavior

The SCP prevents principals from creating new CloudWatch Log Groups by denying:

```json
{
  "Effect": "Deny",
  "Action": "logs:CreateLogGroup",
  "Resource": "*"
}
```

Existing log groups **remain functional** and applications can continue writing logs normally.

## Module Usage

### Example:

```hcl
module "scp_deny_cw_log_group" {
  source = "./modules/scp_deny_cw_log_group"

  enabled_account_ids = [
    "111111111111", # account 1
    "222222222222", # account 2
  ]
}
```

Add additional accounts progressively as part of controlled rollout.

### Inputs

| Variable              | Type          | Default                                  | Description                               |
| --------------------- | ------------- | ---------------------------------------- | ----------------------------------------- |
| `name`                | `string`      | `DenyCloudWatchLogGroupCreation`         | SCP name                                  |
| `description`         | `string`      | Block creation of CloudWatch log groups. | SCP description                           |
| `enabled_account_ids` | `set(string)` | `[]`                                     | List of account IDs where SCP is attached |

## Important Notes

- This module must be executed from the **AWS Organizations management account** or a delegated admin for SCPs.
- Do **NOT** attach this SCP to the Root unless intended. By design, the module attaches only to accounts you specify.
- Some services (e.g., new Lambda functions) may fail if they attempt to create log groups. Pre-create log groups if required.
