locals {
    tenant_files = fileset(
        path.module, "tenants/*.{yml,yaml}"
    )
    tenants_contents = {
        for file in local.tenant_files :
        basename(file) => yamldecode(file(file))
    }
    tenants = {
        for k, v in local.tenants_contents :
        v.name => v
    }
}
