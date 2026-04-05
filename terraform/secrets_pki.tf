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
    ttl        = 3600
    max_ttl    = 86400
    no_store   = true

    # Domain Handling
    allowed_domains             = [ "blackquartz.io" ]
    allow_wildcard_certificates = false
    allow_subdomains            = true
    allow_ip_sans               = false
    allow_localhost             = false
    enforce_hostnames           = true

    # Key Parameters
    key_type      = "ec"
    key_usage     = [ "DigitalSignature", "KeyAgreement" ]
    ext_key_usage = [ "ServerAuth", "ClientAuth" ] 
}

resource "vault_pki_secret_backend_role" "internal" {
    # Role Parameters
    backend    = vault_mount.pki.path
    name       = "internal"
    issuer_ref = "default"
    ttl        = 3600
    max_ttl    = 86400
    no_store   = true

    # Domain Handling
    allowed_domains = [ "svc.cluster.local" ]
    allow_wildcard_certificates = false 
    allow_subdomains            = true
    allow_ip_sans               = true
    allow_localhost             = true  
    enforce_hostnames           = true

    # Key Parameters
    key_type      = "ec"
    key_usage     = [ "DigitalSignature", "KeyAgreement" ]
    ext_key_usage = [ "ServerAuth", "ClientAuth" ] 
}



