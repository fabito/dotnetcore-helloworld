output "default_site_hostname " {
    value = "${azurerm_app_service.test.default_site_hostname}"
}

output "staging_site_hostname " {
    value = "${azurerm_app_service_slot.test.default_site_hostname}"
}
