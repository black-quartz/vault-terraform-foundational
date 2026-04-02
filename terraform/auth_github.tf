###############################
### GitHub JWT Auth Backend ###
###############################

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
