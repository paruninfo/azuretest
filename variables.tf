variable "resource_group_location" {
  type        = string
  default     = "eastus-2"
}

variable "resource_group_name" {
  type        = string
  default     = "az-eastus-rg-applicationname"
}

variable "sql_db_name" {
  type        = string
  description = "The name of the SQL Database."
  default     = "testdatabase"
}

variable "admin_username" {
  type        = string
  description = "The administrator username of the SQL logical server."
  default     = "azureadmin"
}

variable "admin_password" {
  type        = string
  description = "The administrator password of the SQL logical server."
  sensitive   = true
  default     = null
}

variable "vnet_name" {
  type        = string
  description = "Enter Virtual Network Name."
  
}
variable "subnet_name" {
  type        = string
  description = "Enter Virtual Network Name."
  
}

variable "var.network_rg_name" {
  type        = string
  description = "Enter Virtual Network resource Group Name."
  
}
