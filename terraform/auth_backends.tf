#########################################
##### Vault Authentication Backends #####
#########################################


### Kubernetes Auth Backend ###

# Backend
resource "vault_auth_backend" "kubernetes" {
    type        = "kubernetes"
    path        = "kubernetes"
    description = "Kubernetes auth backend for pod identity authentication."
}

# Backend Config
resource "vault_kubernetes_auth_backend_config" "kubernetes" {
    backend                = vault_auth_backend.kubernetes.path
    kubernetes_host        = var.kubernetes_host
    issuer                 = "api"
    disable_iss_validation = true 
}

# Backend Roles
resource "vault_kubernetes_auth_backend_role" "cert_manager" {
    backend                          = vault_auth_backend.kubernetes.path
    role_name                        = "cert-manager"
    bound_service_account_names      = [ "cert-manager" ]
    bound_service_account_namespaces = [ "cert-manager"]
    token_policies                   = [ "cert-manager" ]
    token_ttl                        = 3600
    audience                         = "vault"
}


### GitHub JWT Auth Backend ###

# Backend
resource "vault_auth_backend" "github" {
    type        = "jwt"
    path        = "jwt"
    description = "JWT auth backend for GitHub Actions workflows."
}

# Backend Config
resource "vault_jwt_auth_backend_config" "github" {
    backend           = vault_auth_backend.github.path
    oidc_discover_url = "https://token.actions.githubusercontent.com"
    bound_issuer      = "https://token.actions.githubusercontent.com"
}

# Backend Roles

