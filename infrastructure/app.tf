# resource "random_id" "server" {
#   keepers = {
#     azi_id = 1
#   }
#   byte_length = 8
# }
resource "azurerm_resource_group" "test" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}
resource "azurerm_app_service_plan" "test" {
  name                = "${var.service_plan_name}"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  kind                = "Linux"

  sku {
    tier = "Standard"
    size = "S1"
  }

  properties {
    reserved = true
  }
}
resource "azurerm_app_service" "test" {
  name                = "${var.app_service_name}"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  app_service_plan_id = "${azurerm_app_service_plan.test.id}"

  site_config {
	always_on = true
    linux_fx_version = "DOCKER|${var.app_service_docker_image}"
  }

  app_settings {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }

}
resource "azurerm_app_service_slot" "test" {
  name                = "${var.app_service_slot_name}"
  app_service_name    = "${azurerm_app_service.test.name}"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  app_service_plan_id = "${azurerm_app_service_plan.test.id}"

  site_config {
	always_on = true
    linux_fx_version = "DOCKER|${var.app_service_docker_image}"
  }

  app_settings {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
}