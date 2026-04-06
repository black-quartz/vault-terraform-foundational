resource "vault_policy" "kubernetes_auth" {
    count = local.kubernetes_auth_enabled ? 1 : 0

    name   = local.kubernetes_auth_policy_name
    policy = local.kubernetes_auth_policy
}

resource "vault_policy" "github_auth" {
    count = local.github_auth_enabled ? 1 : 0

    name   = local.github_auth_policy_name
    policy = local.github_auth_policy
}

resource "vault_jwt_auth_backend_role" "this" {
    count = local.github_auth_enabled ? 1 : 0

    backend        = var.github_auth_backend_path
    role_name      = var.name
    token_policies = [ vault_policy.github_auth[0].name ]
    token_ttl      = var.github_auth_backend.token_ttl
    token_max_ttl  = var.github_auth_backend.token_max_ttl

    role_type       = "jwt"
    user_claim      = "actor"
    bound_audiences = ["https://github.com/black-quartz"]
    bound_claims    = var.github_auth_backend.bound_claims


}

resource "vault_kubernetes_auth_backend_role" "this" {
    count = local.kubernetes_auth_enabled ? 1 : 0

    backend        = var.kubernetes_auth_backend_path
    role_name      = var.name
    token_policies = [ vault_policy.kubernetes_auth[0].name ]
    token_ttl      = var.kubernetes_auth_backend.token_ttl
    token_max_ttl  = var.kubernetes_auth_backend.token_max_ttl

    bound_service_account_names      = var.kubernetes_auth_backend.bound_service_account_names
    bound_service_account_namespaces = var.kubernetes_auth_backend.bound_service_account_namespaces
}

resource "vault_kubernetes_secret_backend_role" "this" {
    count = local.kubernetes_secrets_enabled ? 1 : 0

    backend           = var.kubernetes_secrets_engine_path
    name              = var.kubernetes_secrets_engine.name
    token_default_ttl = var.kubernetes_secrets_engine.token_default_ttl
    token_max_ttl     = var.kubernetes_secrets_engine.token_max_ttl 

    kubernetes_role_name          = var.kubernetes_secrets_engine.kubernetes_role_name
    kubernetes_role_type          = var.kubernetes_secrets_engine.kubernetes_role_type
    allowed_kubernetes_namespaces = var.kubernetes_secrets_engine.allowed_kubernetes_namespaces
}
