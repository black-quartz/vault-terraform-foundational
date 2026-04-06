module "tenants" {
    source = "./modules/tenant"

    for_each = local.tenants

    name            = each.value.name
    auth_backends   = each.value.auth_backends
    secrets_engines = each.value.secrets_engines

    github_auth_backend_path     = vault_jwt_auth_backend.github.path
    kubernetes_auth_backend_path = vault_auth_backend.kubernetes.path

    kubernetes_secrets_engine_path = vault_kubernetes_secret_backend.kubernetes.path
    kv_secrets_engine_path         = vault_mount.kv_v2.path
}