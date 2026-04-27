##################################
### Kubernetes Secrets Backend ###
##################################

resource "vault_kubernetes_secret_backend" "kubernetes" {
    path                 = var.kubernetes_secrets_engine_path
    description          = "Generate ephemeral Kubernetes credentials with scoped access."
    kubernetes_host      = "https://kubernetes.default.svc"
    disable_local_ca_jwt = false
}

##########################
### KV Secrets Backend ###
##########################

resource "vault_mount" "kv_v2" {
    path        = var.kv_secrets_engine_path
    type        = "kv-v2"
    description = "Securely store and access generic secrets in Vault."

    options = {
        version = "2"
        type    = "kv-v2"
    }       
}

resource "vault_kv_secret_backend_v2" "kv_v2" {
  mount        = vault_mount.kv_v2.path
  max_versions = 3
}

###########################
### PKI Secrets Backend ###
###########################

resource "vault_mount" "pki" {
    path                      = var.pki_secrets_engine_path
    type                      = "pki"
    description               = "Issue PKI certificates to encrypt internal network traffic."
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
    allowed_domains             = ["ilysium.io"]
    allow_any_name              = false 
    allow_wildcard_certificates = true
    allow_subdomains            = true
    allow_ip_sans               = false
    allow_localhost             = false
    enforce_hostnames           = true

    # Key Parameters
    key_type      = "ec"
    key_bits      = "256" 
    key_usage     = ["DigitalSignature", "KeyAgreement"]
    ext_key_usage = ["ServerAuth", "ClientAuth"] 
}

resource "vault_pki_secret_backend_role" "kubernetes" {
    # Role Parameter
    backend    = vault_mount.pki.path
    name       = "kubernetes"
    issuer_ref = "default"
    ttl        = 86400 # 24h
    max_ttl    = 86400 # 24h
    no_store   = true

    # Domain Handling
    allowed_domains             = ["prod-us.ilysium.io"]
    allow_any_name              = false
    allow_wildcard_certificates = true
    allow_subdomains            = true
    allow_ip_sans               = true
    allow_localhost             = true  
    enforce_hostnames           = true

    # Key Parameters
    key_type      = "ec"
    key_bits      = "256"
    key_usage     = ["DigitalSignature", "KeyAgreement"]
    ext_key_usage = ["ServerAuth", "ClientAuth"] 
}
