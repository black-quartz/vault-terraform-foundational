##################################
### Kubernetes Secrets Backend ###
##################################

resource "vault_kubernetes_secret_backend" "kubernetes" {
    path                 = "kubernetes"
    kubernetes_host      = "https://kubernetes.default.svc"
    disable_local_ca_jwt = false
}

resource "vault_kubernetes_secret_backend_role" "vault_deploy" {
    backend                       = vault_kubernetes_secret_backend.kubernetes.path
    name                          = "vault-deploy"
    kubernetes_role_name          = "contributor"
    kubernetes_role_type          = "ClusterRole"
    allowed_kubernetes_namespaces = ["vault"]

    token_default_ttl = 1800 # 30m
    token_max_ttl     = 3600 # 1hr
}

resource "vault_kubernetes_secret_backend_role" "twingate_deploy" {
    backend                       = vault_kubernetes_secret_backend.kubernetes.path
    name                          = "twingate-deploy"
    kubernetes_role_name          = "contributor"
    kubernetes_role_type          = "ClusterRole"
    allowed_kubernetes_namespaces = ["twingate"]

    token_default_ttl = 1800
    token_max_ttl     = 3600
}