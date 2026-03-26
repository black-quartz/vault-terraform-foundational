path "pki/sign/gateway" {
    capabilities = ["update"]
}

path "pki/ca_chain" {
  capabilities = ["read"]
}

path "pki/crl" {
  capabilities = ["read"]
}