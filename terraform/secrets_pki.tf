###########################
### PKI Secrets Backend ###
###########################

resource "vault_mount" "pki" {
    path                      = "pki"
    type                      = "pki"
    description               = "Black Quartz Issuing CA"

    default_lease_ttl_seconds = 86400 # 24h
    max_lease_ttl_seconds     = 86400 # 24h
}

resource "vault_pki_secret_backend_role" "gateway" {
    # Role Parameters
    backend    = vault_mount.pki.path
    name       = "gateway"
    issuer_ref = "default"
    ttl        = 86400 # 24h
    max_ttl    = 86400 # 24h
    no_store   = true

    # Domain Handling
    allowed_domains             = ["blackquartz.io"]
    allow_any_name              = false 
    allow_wildcard_certificates = false
    allow_subdomains            = true
    allow_ip_sans               = false
    allow_localhost             = false
    enforce_hostnames           = true

    # Key Parameters
    key_type      = "ec"
    key_bits      = "256" 
    key_usage     = [ "DigitalSignature", "KeyAgreement" ]
    ext_key_usage = [ "ServerAuth", "ClientAuth" ] 
}

resource "vault_pki_secret_backend_role" "internal" {
    # Role Parameters
    backend    = vault_mount.pki.path
    name       = "internal"
    issuer_ref = "default"
    ttl        = 86400 # 24h
    max_ttl    = 86400 # 24h
    no_store   = true

    # Domain Handling
    allowed_domains             = [ "svc.cluster.local" ]
    allow_any_name              = false
    allow_wildcard_certificates = true
    allow_subdomains            = true
    allow_ip_sans               = true
    allow_localhost             = true  
    enforce_hostnames           = true

    # Key Parameters
    key_type      = "ec"
    key_bits      = "256"
    key_usage     = [ "DigitalSignature", "KeyAgreement" ]
    ext_key_usage = [ "ServerAuth", "ClientAuth" ] 
}

resource "vault_policy" "cert_manager" {
    name = "platform-cert-manager-kubernetes_auth"

    policy = <<EOT
        path "pki/sign/internal" {
          capabilities = ["create", "update"]
        }

        path "pki/issue/internal" {
          capabilities = ["create", "update"]
        }

        path "pki/sign/gateway" {
          capabilities = ["create", "update"]
        }

        path "pki/issue/gateway" {
          capabilities = ["create", "update"]
        }

        path "pki/ca_chain" {
          capabilities = ["read"]
        }
    EOT
}
resource "vault_kubernetes_auth_backend_role" "cert_manager" {
    backend                          = vault_auth_backend.kubernetes.path
    role_name                        = "cert-manager"
    bound_service_account_names      = [ "cert-manager" ]
    bound_service_account_namespaces = [ "cert-manager"]
    token_policies                   = [ "cert-manager" ]
    token_ttl                        = 3600
}


