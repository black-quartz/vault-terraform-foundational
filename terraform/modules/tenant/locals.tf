# Enabled Vault auth backends for tenant
locals {
    github_auth_enabled = alltrue([
        var.github_auth_backend != null,
        try(var.github_auth_backend.enabled, false)
    ])
    kubernetes_auth_enabled = alltrue([
        var.kubernetes_auth_backend != null,
        try(var.kubernetes_auth_backend.enabled, false)
    ])
}

# Enabled Vault secrets engines for tenant
locals {
    kubernetes_secrets_enabled = alltrue([
        var.kubernetes_secrets_engine != null,
        try(var.kubernetes_secrets_engine.enabled, false)
    ])
    kv_secrets_enabled = alltrue([
        var.kv_secrets_engine != null,
        try(var.kv_secrets_engine.enabled, false)
    ])
}

locals {
    # Define policy for GitHub authenticated identities
    github_auth_policy_parts = compact([
        local.kv_secrets_enabled ? templatefile("${path.module}/policies/kv-read.hcl.tpl", {
            secrets_engine_path = var.kv_secrets_engine_path
            tenant_path         = var.kv_secrets_engine.path
        }) : null,
        local.kubernetes_secrets_enabled ? templatefile("${path.module}/policies/kubernetes-creds.hcl.tpl", {
            secrets_engine_path = var.kubernetes_secrets_engine_path
            tenant_path         = var.kubernetes_secrets_engine.name
        }) : null
    ])
    github_auth_policy_name = "tenant-${var.name}-github-auth"
    github_auth_policy = join("\n\n", local.github_auth_policy_parts)

    # Define policy for Kubernetes authenticated identities
    kubernetes_auth_policy_parts = compact([
        local.kv_secrets_enabled ? templatefile("${path.module}/policies/kv-read.hcl.tpl", {
            secrets_engine_path = var.kv_secrets_engine_path
            tenant_path         = var.kv_secrets_engine.path
        }) : null
    ])
    kubernetes_auth_policy_name = "tenant-${var.name}-kubernetes-auth"
    kubernetes_auth_policy = join("\n\n", local.kubernetes_auth_policy_parts)
}