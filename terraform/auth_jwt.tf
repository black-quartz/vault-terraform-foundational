###############################
### GitHub JWT Auth Backend ###
###############################

resource "vault_jwt_auth_backend" "github" {
    path               = "jwt"
    type               = "jwt"
    oidc_discovery_url = "https://token.actions.githubusercontent.com"
    bound_issuer       = "https://token.actions.githubusercontent.com"
}

