resource "azurerm_firewall" "hub_firewall" {
  name                = "${var.name_prefix}-hub-firewall"
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "${var.name_prefix}-hub-firewall-ip-configuration"
    subnet_id            = azurerm_subnet.hub_firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.hub_firewall_public_ip.id
  }

  tags = var.tags
}

resource "azurerm_public_ip" "hub_firewall_public_ip" {
  name                = "${var.name_prefix}-hub-firewall-public-ip"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Network rules for the hub firewall
# TODO: use firewall policy instead of individual rules

locals {
  metastore_ips = toset(flatten([for k, v in data.dns_a_record_set.metastores : v.addrs]))
  eventhubs_ips = toset(flatten([for k, v in data.dns_a_record_set.eventhubs : v.addrs]))
  scc_relay_ips = toset(flatten([for k, v in data.dns_a_record_set.scc_relay : v.addrs]))
}

data "dns_a_record_set" "metastores" {
  for_each = toset(var.metastores)
  host     = each.value
}

data "dns_a_record_set" "eventhubs" {
  for_each = toset(var.eventhubs)
  host     = each.value
}

data "dns_a_record_set" "scc_relay" {
  for_each = toset(var.scc_relay)
  host     = each.value
}

resource "azurerm_firewall_network_rule_collection" "network_rules" {
  name                = "adbcontrolplanenetwork"
  azure_firewall_name = azurerm_firewall.hub_firewall.name
  resource_group_name = var.rg_name
  priority            = 200
  action              = "Allow"

  rule {
    name = "databricks-webapp"

    source_addresses = [
      join(", ", module.vnet_with_ws.firewall_subnet_address_prefixes),
    ]

    destination_ports = [
      "443", "8443-8451",
    ]

    destination_addresses = var.webapp_ips

    protocols = [
      "TCP",
    ]
  }

  rule {
    name = "databricks-metastore"

    source_addresses = [
      join(", ", module.vnet_with_ws.firewall_subnet_address_prefixes),
    ]

    destination_addresses = local.metastore_ips
    destination_ports     = ["3306"]
    protocols = [
      "TCP",
    ]
  }

  rule {
    name = "databricks-eventhubs"

    source_addresses = [
      join(", ", module.vnet_with_ws.firewall_subnet_address_prefixes),
    ]

    destination_addresses = local.eventhubs_ips
    destination_ports     = ["9093"]
    protocols = [
      "TCP",
    ]
  }
}

# Application rules for the hub firewall
resource "azurerm_firewall_application_rule_collection" "application_rules" {
  name                = "adbcontrolplanefqdn"
  azure_firewall_name = azurerm_firewall.hub_firewall.name
  resource_group_name = var.rg_name
  priority            = 200
  action              = "Allow"

  rule {
    name = "databricks-control-plane-services"

    source_addresses = [
      join(", ", module.vnet_with_ws.firewall_subnet_address_prefixes),
    ]

    target_fqdns = var.databricks_fqdns

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name = "databricks-additional-allowed-fqdns"

    source_addresses = [
      join(", ", module.vnet_with_ws.firewall_subnet_address_prefixes),
    ]

    target_fqdns = var.additional_allowed_fqdns

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name = "databricks-dbfs"

    source_addresses = [
      join(", ", module.vnet_with_ws.firewall_subnet_address_prefixes),
    ]

    target_fqdns = ["${module.vnet_with_ws.dbfs_storage_account_name}.dfs.core.windows.net", "${module.vnet_with_ws.dbfs_storage_account_name}.blob.core.windows.net"]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  # TODO: add dynamic rule for additional storage accounts, similar to the one for DBFS

  rule {
    name = "databricks-scc-relay"

    source_addresses = [
      join(", ", module.vnet_with_ws.firewall_subnet_address_prefixes),
    ]

    target_fqdns = var.scc_relay

    protocol {
      port = "443"
      type = "Https"
    }
  }

  # TODO: add more application rules for the hub firewall

}
