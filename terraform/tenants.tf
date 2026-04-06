module "tenants" {
    source = "./modules/tenant"

    for_each = local.tenants

    name = each.value.name
    
    github_auth_backend       = try(each.value.auth_backends.github, null)
    kubernetes_auth_backend   = try(each.value.auth_backends.kubernetes, null)
    kubernetes_secrets_engine = try(each.value.secrets_engines.kubernetes, null)
    kv_secrets_engine         = try(each.value.secrets_engines.kv, null)

    github_auth_backend_path       = vault_jwt_auth_backend.github.path
    kubernetes_auth_backend_path   = vault_auth_backend.kubernetes.path
    kubernetes_secrets_engine_path = vault_kubernetes_secret_backend.kubernetes.path
    kv_secrets_engine_path         = vault_mount.kv_v2.path
}