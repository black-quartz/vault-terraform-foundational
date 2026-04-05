# Enabled Vault auth backends for tenant
locals {
    github_auth_enabled = alltrue([
        var.auth_backends.github != null,
        try(var.auth_backends.github.enabled, false)
    ])
    kubernetes_auth_enabled = alltrue([
        var.auth_backends.kubernetes != null,
        try(var.auth_backends.kubernetes.enabled, false)
    ])
}

# Enabled Vault secrets engines for tenant
locals {
    kubernetes_secrets_enabled = alltrue([
        var.secrets_engines.kubernetes != null,
        try(var.secrets_engines.kubernetes.enabled, false)
    ])
    kv_secrets_enabled = alltrue([
        var.secrets_engines.kv != null,
        try(var.secrets_engines.kv.enabled, false)
    ])
}

locals {
    # Define policy for GitHub authenticated identities
    github_auth_policy_parts = compact([
        local.kv_secrets_enabled ? templatefile("${path.module}/policies/kv-read.hcl.tpl", {
            secrets_engine_path = var.vault_paths.secrets.kv
            tenant_path         = var.secrets_engines.kv.path
        }) : null,
        local.kubernetes_secrets_enabled ? templatefile("${path.module}/policies/kubernetes-creds.hcl.tpl", {
            secrets_engine_path = var.vault_paths.secrets.kubernetes
            tenant_path         = var.secrets_engines.kubernetes.name
        }) : null
    ])
    github_auth_policy_name = "tenant-${var.name}-github-auth"
    github_auth_policy = join("\n\n", local.github_auth_policy_parts)

    # Define policy for Kubernetes authenticated identities
    kubernetes_auth_policy_parts = compact([
        local.kv_secrets_enabled ? templatefile("${path.module}/policies/kv-read.hcl.tpl", {
            secrets_engine_path = var.vault_paths.secrets.kv
            tenant_path         = var.secrets_engines.kv.path
        }) : null
    ])
    kubernetes_auth_policy_name = "tenant-${var.name}-kubernetes-auth"
    kubernetes_auth_policy = join("\n\n", local.kubernetes_auth_policy_parts)
}