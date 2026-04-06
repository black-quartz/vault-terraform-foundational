##################################
### Kubernetes Secrets Backend ###
##################################

resource "vault_kubernetes_secret_backend" "kubernetes" {
    path                 = "kubernetes"
    kubernetes_host      = "https://kubernetes.default.svc"
    disable_local_ca_jwt = false
}

##########################
### KV Secrets Backend ###
##########################

resource "vault_mount" "kv_v2" {
    path        = "kv"
    type        = "kv-v2"
    description = "KV v2 Secrets Engine mount"

    options = {
        version = "2"
        type    = "kv-v2"
    }       
}

resource "vault_kv_secret_backend_v2" "example" {
  mount        = vault_mount.kv_v2.path
  max_versions = 3
}

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
