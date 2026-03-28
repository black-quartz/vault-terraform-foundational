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

resource "vault_jwt_auth_backend" "github" {
    path               = "jwt"
    type               = "jwt"
    oidc_discovery_url = "https://token.actions.githubusercontent.com"
    bound_issuer       = "https://token.actions.githubusercontent.com"
}

resource "vault_jwt_auth_backend_role" "vault_deploy" {
    backend        = vault_jwt_auth_backend.github.path
    role_name      = "vault-deploy"
    token_policies = ["vault-deploy"]

    role_type  = "jwt"
    user_claim = "actor"

    bound_audiences = ["https://github.com/black-quartz"]
    bound_claims = {
      repository = "black-quartz/vault-deployment"
    }

    token_ttl     = 900 # 15m
    token_max_ttl = 900 # 15m
}

resource "vault_jwt_auth_backend_role" "twingate_deploy" {
    backend        = vault_jwt_auth_backend.github.path
    role_name      = "twingate-deploy"
    token_policies = ["twingate-deploy"]

    role_type  = "jwt"
    user_claim = "actor"

    bound_audiences = ["https://github.com/black-quartz"]
    bound_claims = {
      repository = "black-quartz/twingate-deployment"
    }

    token_ttl     = 900 # 15m
    token_max_ttl = 900 # 15m
}