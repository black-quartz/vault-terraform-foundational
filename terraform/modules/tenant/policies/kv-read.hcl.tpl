# Allows for read-only access to the specified KV secrets path.
path "${secrets_engine_path}/data/${tenant_path}/*" {
  capabilities = ["create", "read", "list"]
}

path "${secrets_engine_path}/metadata/${tenant_path}/*" {
  capabilities = ["read", "list", "delete"]
}