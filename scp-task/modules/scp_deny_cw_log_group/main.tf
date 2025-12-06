resource "aws_organizations_policy" "deny_cw_log_group_creation" {
  name        = var.name
  description = var.description
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyCreateLogGroup"
        Effect = "Deny"
        Action = [
          "logs:CreateLogGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "attachments" {
  for_each = var.enabled_account_ids

  policy_id = aws_organizations_policy.deny_cw_log_group_creation.id
  target_id = each.key
}
