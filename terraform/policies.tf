locals {
    policy_files = fileset(path.module, "hcl/**/*.hcl")
    policies = {
        for file in local.policy_files :
        trimsuffix(basename(file), ".hcl") => file(file) 
    }
}

resource "vault_policy" "policies" {
    for_each = local.policies
    name   = each.key
    policy = each.value
}