#################################
##### Vault Secret Backends #####
#################################

### Kubernetes Secrets Backend ###

resource "vault_kubernetes_secret_backend" "kubernetes" {
    path                 = "kubernetes"
    kubernetes_host      = var.kubernetes_host
    disable_local_ca_jwt = false
}

resource "vault_kubernetes_secret_backend_role" "vault_deploy" {
    backend                       = vault_kubernetes_secret_backend.kubernetes.path
    name                          = "vault-deploy"
    kubernetes_role_name          = "contributor"
    kubernetes_role_type          = "ClusterRole"
    allowed_kubernetes_namespaces = ["vault"]

    token_default_ttl = 1800 # 30m
    token_max_ttl     = 3600 # 1hr
}


### PKI Secrets Backend ###

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
    key_type      = "ed25519"
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
    allowed_domains = [ "svc.cluster.local", "pod.cluster.local" ]
    allow_wildcard_certificates = false 
    allow_subdomains            = true
    allow_ip_sans               = true
    allow_localhost             = true  
    enforce_hostnames           = true

    # Key Parameters
    key_type      = "ed25519"
    key_usage     = [ "DigitalSignature", "KeyAgreement" ]
    ext_key_usage = [ "ServerAuth", "ClientAuth" ] 
}



