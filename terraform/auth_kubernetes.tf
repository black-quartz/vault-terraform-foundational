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
    kubernetes_host        = var.kubernetes_host
    issuer                 = "api"
    disable_iss_validation = true 
}

