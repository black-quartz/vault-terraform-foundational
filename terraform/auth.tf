###############################
### GitHub JWT Auth Backend ###
###############################

resource "vault_jwt_auth_backend" "github" {
    path               = var.github_auth_backend_path
    type               = "jwt"
    description        = "Use GitHub OIDC to authenticate to Vault." 
    oidc_discovery_url = "https://token.actions.githubusercontent.com"
    bound_issuer       = "https://token.actions.githubusercontent.com"
}

###############################
### Kubernetes Auth Backend ###
###############################

resource "vault_auth_backend" "kubernetes" {
    path        = var.kubernetes_auth_backend_path
    type        = "kubernetes"
    description = "Use Kubernetes service account credentials to authenticate to Vault."
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
    backend                = vault_auth_backend.kubernetes.path
    kubernetes_host        = var.kubernetes_host
    issuer                 = "api"
    disable_iss_validation = true 
}

