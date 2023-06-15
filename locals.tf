locals {
  default_name = "medline"
  ip_name      = var.ip_name != "" ? var.ip_name : join("-", [local.default_name, "pubip"])
  ip_label     = var.ip_label != "" ? var.ip_label : join("-", [local.default_name, "pubip"])

  frontend_ip_configuration_name      = var.frontend_ip_configuration_name != "" ? var.frontend_ip_configuration_name : join("-", [local.default_name, "frontipconfig"])
  frontend_priv_ip_configuration_name = var.frontend_priv_ip_configuration_name != "" ? var.frontend_priv_ip_configuration_name : join("-", [local.default_name, "frontprivipconfig"])
  gateway_ip_configuration_name       = var.gateway_ip_configuration_name != "" ? var.gateway_ip_configuration_name : join("-", [local.default_name, "gwipconfig"])

  default_tags = {
    "Environment" = var.environment
  }
}