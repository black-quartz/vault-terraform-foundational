###############################
### Kubernetes Auth Backend ###
###############################

resource "vault_auth_backend" "kubernetes" {
    type        = "kubernetes"
    path        = "kubernetes"
    description = "Kubernetes auth backend for pod identity authentication."
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
    backend                = vault_auth_backend.kubernetes.path
    kubernetes_host        = "https://kubernetes.default.svc"
    issuer                 = "api"
    disable_iss_validation = true 
}

resource "vault_kubernetes_auth_backend_role" "cert_manager" {
    backend                          = vault_auth_backend.kubernetes.path
    role_name                        = "cert-manager"
    bound_service_account_names      = [ "cert-manager" ]
    bound_service_account_namespaces = [ "cert-manager"]
    token_policies                   = [ "cert-manager" ]
    token_ttl                        = 3600
}
