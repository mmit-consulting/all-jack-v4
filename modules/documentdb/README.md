# Terraform Module – AWS DocumentDB

This Terraform module provisions an **Amazon DocumentDB (MongoDB-compatible) cluster** using a **security-first, enterprise-ready approach**.

The module is designed to:

- Create **DocumentDB clusters and instances**
- Integrate with **AWS Secrets Manager (read-only)**
- Align with **separation of duties** (secrets are created outside Terraform)

---

## 📌 Key Design Principles

- **Secrets are NOT created by Terraform**
  - The master password **must already exist** in AWS Secrets Manager
  - Terraform **only reads** the secret at apply time
- **Least privilege & audit-friendly**
- **Scales cleanly** with `for_each`
- **Production-ready defaults** (logs, monitoring, encryption)

---

## 📦 What This Module Creates

For each cluster, the module provisions:

- ✅ `aws_docdb_cluster`
- ✅ `aws_docdb_cluster_instance` (1 writer + N replicas)
- ✅ `aws_docdb_subnet_group`
- ✅ CloudWatch Logs exports (`audit`, `profiler`)
- ✅ Performance Insights (optional)
- ❌ No Secrets Manager resources (by design)

---

## 🔐 Secret Management (IMPORTANT)

### Secret **MUST** be created manually in AWS Console

When creating the secret in **AWS Secrets Manager**, select: `Secret type: Other type of secret`

### Secret value format (required)

```json
{
  "username": "appservice",
  "password": "STRONG_PASSWORD"
}
```

- password → required
- username → optional (falls back to module variable if absent)

## Why NOT “DocumentDB credentials” secret type?

- Requires an existing cluster
- Designed for AWS-managed rotation
- Conflicts with Terraform-driven cluster creation

This module intentionally uses read-only secret consumption.
