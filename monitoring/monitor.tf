data "ibm_resource_group" "group" {
  name = "Default"
}

module "monitoring" { 
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-cloud-monitoring.git?ref=d147145b08e6ddadf2756cfb096a4174d580a4b8"

  resource_group_id = data.ibm_resource_group.group.id
  region            = "eu-gb" # you can change this to your own region
  plan              = "lite"
}