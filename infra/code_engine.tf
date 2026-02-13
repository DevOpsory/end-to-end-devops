data "ibm_resource_group" "group" {
  name = "Default"
}

resource "ibm_code_engine_project" "devops_ce_project" {
  name              = "end_to_end_devops"
  resource_group_id = data.ibm_resource_group.group.id
}
