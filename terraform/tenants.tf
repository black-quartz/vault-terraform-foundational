module "tenants" {
    source = "./modules/tenant"

    for_each = local.tenants

    name             = each.value.name
    auth_backends    = each.value.auth_backends
    secrets_engines  = each.value.secrets_engines

    vault_paths = {
        auth = {
            github     = vault_jwt_auth_backend.github.path
            kubernetes = vault_auth_backend.kubernetes.path
        }
        secrets = {
            kubernetes = vault_kubernetes_secret_backend.kubernetes.path
            kv         = vault_mount.kv_v2.path
        }
    }
}