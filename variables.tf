# Common
variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}
variable "vnet_rg" {
  type = string
}
variable "subnet_name" {
  type = string
}
variable "environment" {
  type = string
}

# PUBLIC IP

variable "ip_name" {
  description = "Public IP name."
  type        = string
  default     = ""
}

variable "ip_label" {
  description = "Domain name label for public IP."
  type        = string
  default     = ""
}

variable "ip_sku" {
  description = "SKU for the public IP. Warning, can only be `Standard` for the moment."
  type        = string
  default     = "Standard"
}

variable "ip_allocation_method" {
  description = "Allocation method for the public IP. Warning, can only be `Static` for the moment."
  type        = string
  default     = "Static"
}

# Application gateway inputs

variable "appgw_name" {
  description = "Application Gateway name."
  type        = string
  default     = ""
}

variable "sku_capacity" {
  description = "The Capacity of the SKU to use for this Application Gateway - which must be between 1 and 10, optional if autoscale_configuration is set"
  type        = number
  default     = 2
}

variable "sku" {
  description = "The Name of the SKU to use for this Application Gateway. Possible values are Standard_v2 and WAF_v2."
  type        = string
  default     = "Standard_v2"
}

variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over. This option is only supported for v2 SKUs"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "autoscaling_parameters" {
  type        = map(string)
  description = "Map containing autoscaling parameters. Must contain at least min_capacity"
  default     = null
}

variable "frontend_ip_configuration_name" {
  description = "The Name of the Frontend IP Configuration used for this HTTP Listener."
  type        = string
  default     = ""
}

variable "frontend_priv_ip_configuration_name" {
  description = "The Name of the private Frontend IP Configuration used for this HTTP Listener."
  type        = string
  default     = ""
}

variable "frontend_port_settings" {
  description = "Frontend port settings. Each port setting contains the name and the port for the frontend port."
  type        = list(map(string))
}

variable "gateway_ip_configuration_name" {
  description = "The Name of the Application Gateway IP Configuration."
  type        = string
  default     = ""
}


## Http Setting

variable "appgw_backend_http_settings" {
  description = "List of maps including backend http settings configurations"
  type        = any
}


## Listener

variable "appgw_http_listeners" {
  description = "List of maps including http listeners configurations and map of maps including listener custom error configurations"
  type        = any
}

## backend_pools
variable "appgw_backend_pools" {
  description = "List of maps including backend pool configurations"
  type        = any
}

## SSL 
variable "ssl_certificates_configs" {
  description = <<EOD
List of maps including ssl certificates configurations.
The path to a base-64 encoded certificate is expected in the 'data' parameter:
```
data = filebase64("./file_path")
```
EOD
  type        = list(map(string))
  default     = []
}

variable "trusted_root_certificate_configs" {
  description = "List of trusted root certificates. The needed values for each trusted root certificates are 'name' and 'data' or 'filename'. This parameter is required if you are not using a trusted certificate authority (eg. selfsigned certificate)"
  type        = list(map(string))
  default     = []
}

variable "ssl_policy" {
  description = "Application Gateway SSL configuration. The list of available policies can be found here: https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-ssl-policy-overview#predefined-ssl-policy"
  type        = any
  default     = null
}

variable "appgw_routings" {
  description = "List of maps including request routing rules configurations"
  type        = list(map(string))
}


## Probes 
variable "appgw_probes" {
  description = "List of maps including request probes configurations"
  type        = any
  default     = []
}

## Path map 

variable "appgw_url_path_map" {
  description = "List of maps including url path map configurations"
  type        = any
  default     = []
}


### APPGW PRIVATE 

variable "appgw_private" {
  description = "Boolean variable to create a private Application Gateway. When `true`, the default http listener will listen on private IP instead of the public IP."
  type        = bool
  default     = false
}

variable "appgw_private_ip" {
  description = "Private IP for Application Gateway. Used when variable `appgw_private` is set to `true`."
  type        = string
  default     = null
}

variable "enable_http2" {
  description = "Whether to enable http2 or not"
  type        = bool
  default     = true
}


### REWRITE RULE SET

variable "appgw_rewrite_rule_set" {
  description = "List of rewrite rule set including rewrite rules"
  type        = any
  default     = []
}

### Redirection 
variable "appgw_redirect_configuration" {
  description = "List of maps including redirect configurations"
  type        = list(map(string))
  default     = []
}


### IDENTITY

variable "user_assigned_identity_id" {
  description = "User assigned identity id assigned to this resource"
  type        = string
  default     = null
}

variable "appgw_tags" {
  description = "Application Gateway tags."
  type        = map(string)
  default     = {}
}
