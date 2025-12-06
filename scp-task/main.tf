module "scp_deny_cw_log_group" {
  source = "./modules/scp_deny_cw_log_group"

  enabled_account_ids = [
    "111111111111", # account A
    "222222222222", # account B
  ]
}
