variable "client_id" {}
variable "client_secret" {}

variable "resource_group_name" {
    default = "HelloWorld"
}

variable "location" {
    default = "West Central US"
}

variable "service_plan_name" {
    default = "HelloWorldServicePlan"
}

variable "app_service_name" {
    default = "serko-helloworld"
}

variable "app_service_slot_name" {
    default = "staging"
}

variable "app_service_docker_image" {
    default = "fabito/dotnetcorehelloworld:6"
}

