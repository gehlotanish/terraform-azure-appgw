## Usage

```terraform
provider "azurerm" {
  features {}
}

module "appgw_v2" {
  source = "git::ssh://git@bitbucket.org//terraform-modules.git//terraform-appgw"

  environment         = "sbx"
  location            = "eastus"
  resource_group_name = "example"
  vnet_name           = "vnetapp"
  vnet_rg             = "example"
  subnet_name         = "default"
  ip_name             = "pubicip"
  ip_label            = "iplabel"
  appgw_name          = "appgw"
  appgw_private       = true
  appgw_private_ip    = "10.0.0.10"

  appgw_backend_http_settings = [{
    name                                = "appgw-backhttpsettings"
    cookie_based_affinity               = "Disabled"
    path                                = "/"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 300
    pick_host_name_from_backend_address = false
    host_name                           = "example.com"
    probe_name                          = "Httpsprobe"
  }]

  appgw_backend_pools = [{
    name  = "appgw-backendpool"
    fqdns = ["example.com"]
  }]

  appgw_routings = [{
    name                       = "appgw-routing-https"
    rule_type                  = "Basic"
    http_listener_name         = "appgw-listener-https"
    backend_address_pool_name  = "appgw-backendpool"
    backend_http_settings_name = "appgw-backhttpsettings"
  }]

  appgw_http_listeners = [{
    name                           = "appgw-listener-https"
    frontend_ip_configuration_name = "appgw-frontipconfig"
    frontend_port_name             = "frontend-https-port"
    protocol                       = "Https"
    ssl_certificate_name           = "sslnew"
    host_name                      = "example.com"
    require_sni                    = true
  }]

  frontend_port_settings = [{
    name = "frontend-https-port"
    port = 443
    },
    {
      name = "frontend-http-port"
      port = 80
    }
  ]

  ssl_certificates_configs = [{
    name     = "sslnew"
    data     = filebase64("./domain.pfx")
    password = "ssl"
  }]

  autoscaling_parameters = {
    min_capacity = 1
    max_capacity = 10
  }

  appgw_probes = [{
    name                                      = "Httpsprobe"
    protocol                                  = "Https"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
  }]

}

```

## Common  Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Enviroment value of resources | `string` | n/a | yes |
| location | location of resources to deploy | `string` | n/a | yes |
| resource_group_name | Resource group name | `string` | n/a | yes |
| vnet_name | Virtual network name to attach with Application gateway | `string` | n/a | yes |
| vnet_rg | Resource group name of  deployed virtual network | `string` | n/a | yes |
| subnet_name | Subnet group name of vnet  | `string` | n/a | yes |
| ip_name | Name of public ip resouce to be create  | `string` | n/a | yes | 
| ip_label | Dns labale name of public ip | `string` | n/a | yes |
| appgw_name | Application gateway name | `string` | n/a | yes |
| appgw_private | Application gateway for private network Boolean if true then required variable appgw_private_ip | `bool` | n/a | yes |
| appgw_private_ip | Private IP for Application Gateway. Used when variable appgw_private is set to true. |  `string` | n/a | yes |


## Http setting
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Http Setting name  | `string` | n/a | yes |
| cookie_based_affinity | (Required) Is Cookie-Based Affinity enabled? Possible values are Enabled and Disabled | `string` | n/a | yes |
| path |  (Optional) The Path which should be used as a prefix for all HTTP requests. |  (Optional) The Path which should be used as a prefix for all HTTP requests.
| port | (Required) The port which should be used for this Backend HTTP Settings Collection. | (Required) The port which should be used for this Backend HTTP Settings Collection.
| protocol | (Required) The Protocol which should be used. Possible values are Http and Https | `string` | n/a | yes |
| request_timeout | (Required) The request timeout in seconds, which must be between 1 and 86400 seconds. | `string` | n/a | yes |
| pick_host_name_from_backend_address |  (Optional) Whether host header should be picked from the host name of the backend server. Defaults to false. | `string` | n/a | yes |
| host_name | Host header to be sent to the backend servers. Cannot be set if pick_host_name_from_backend_address is set to true | `string` | n/a | yes |
| probe_name | (Optional) The name of an associated HTTP Probe. | `string` | n/a | yes |


## Appgw backend pools

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of bancked pools | `string` | n/a | yes |
| fqdns |  (Optional) A list of FQDN's which should be part of the Backend Address Pool. | `string` | n/a | yes |
| ip_addresses | (Optional) A list of IP Addresses which should be part of the Backend Address Pool. | `string` | n/a | yes |

## Appgw routings 

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Applicatio gateway routing name | `string` | n/a | yes |
| rule_type |  (Required) The Type of Routing that should be used for this Rule. Possible values are Basic and PathBasedRouting | `string` | n/a | yes |
| http_listener_name | (Required) The Name of the HTTP Listener which should be used for this Routing Rule. | `string` | n/a | yes |
| backend_address_pool_name | (Optional) The Name of the Backend Address Pool which should be used for this Routing Rule. Cannot be set if redirect_configuration_name is set. | `string` | n/a | yes |
| backend_http_settings_name | (Optional) The Name of the Backend HTTP Settings Collection which should be used for this Routing Rule. Cannot be set if redirect_configuration_name is set. | `string` | n/a | yes |
| redirect_configuration_name |  (Optional) The Name of the Redirect Configuration which should be used for this Routing Rule. Cannot be set if either backend_address_pool_name or backend_http_settings_name is set. | `string` | n/a | yes |
| rewrite_rule_set_name | (Optional) The Name of the Rewrite Rule Set which should be used for this Routing Rule. Only valid for v2 SKUs. | `string` | n/a | yes |

## Appgw http listeners

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of http listener | `string` | n/a | yes |
| frontend_ip_configuration_name | (Required) The Name of the Frontend IP Configuration used for this HTTP Listener. | `string` | n/a | yes |
| frontend_port_name |  (Required) The Name of the Frontend Port use for this HTTP Listener. | `string` | n/a | yes |
| protocol | (Required) The Protocol to use for this HTTP Listener. Possible values are Http and Https. | `string` | n/a | yes |
| ssl_certificate_name | (Optional) The name of the associated SSL Certificate which should be used for this HTTP Listener. | `string` | n/a | yes |
| host_name | (Optional) The Hostname which should be used for this HTTP Listener. Setting this value changes Listener Type to 'Multi site'. | `string` | n/a | yes |
| require_sni  | (Optional) Should Server Name Indication be Required? Defaults to false. | `string` | n/a | yes |

 
## frontend_port_settings 

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | name of frontend port | `string` | n/a | yes |
| port | port to be used 80 or 443 | `string` | n/a | yes |

## ssl_certificates_configs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | (Required) The Name of the SSL certificate that is unique within this Application Gateway. | `string` | n/a | yes |
| data | (Optional) PFX certificate. Required if key_vault_secret_id is not set. | `string` | n/a | yes |
| password | - (Optional) Password for the pfx file specified in data. Required if data is set | `string` | n/a | yes |
| key_vault_secret_id | (Optional) Secret Id of (base-64 encoded unencrypted pfx) Secret or Certificate object stored in Azure KeyVault. You need to enable soft delete for keyvault to use this feature. Required if data is not set. | `string` | n/a | yes |


## Autoscaling parameters

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| min_capacity | (Required) Minimum capacity for autoscaling. Accepted values are in the range 0 to 100. | `number` | n/a | yes |
| max_capacity | (Optional) Maximum capacity for autoscaling. Accepted values are in the range 2 to 125. | `number` | n/a | yes |

## Appgw probes

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The Name of the Probe. | `string` | n/a | yes |
| protocol | The Protocol used for this Probe. Possible values are Http and Https. | `string` | n/a | yes |
| path | The Path used for this Probe. | `string` | n/a | yes |
| interval | The Interval between two consecutive probes in seconds. Possible values range from 1 second to a maximum of 86,400 seconds. | `string` | n/a | yes |
| timeout  | (Required) The Timeout used for this Probe, which indicates when a probe becomes unhealthy. Possible values range from 1 second to a maximum of 86,400 seconds. | `string` | n/a | yes |
| unhealthy_threshold | (Required) The Unhealthy Threshold for this Probe, which indicates the amount of retries which should be attempted before a node is deemed unhealthy. Possible values are from 1 - 20 seconds. | `string` | n/a | yes |
| pick_host_name_from_backend_http_settings | Whether the host header should be picked from the backend http settings. Defaults to false. | `string` | n/a | yes |
| host | (Optional) The Hostname used for this Probe. If the Application Gateway is configured for a single site, by default the Host name should be specified as ‘127.0.0.1’, unless otherwise configured in custom probe. Cannot be set if pick_host_name_from_backend_http_settings is set to true. | `string` | n/a | yes |
| minimum_servers | The minimum number of servers that are always marked as healthy. Defaults to 0. | `string` | n/a | yes |



