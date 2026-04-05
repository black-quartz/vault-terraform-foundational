# Allows generating ephemeral Kubernetes credentials for the specified role
path "${secrets_engine_path}/creds/${tenant_path}" {
    capabilities = ["read", "create", "update"]
}