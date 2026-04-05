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