variable "app_name" {}
variable "env" {}
variable "region" {}

variable "vpc_id" {}
variable "private_subnets_ids" {}
variable "public_subnets_ids" {}

variable "container_port" {}
variable "task_memory" {}
variable "task_cpu" {}
variable "allowed_cidrs" {}
variable "healthcheck_url" {}

variable "private_access" {}

variable "repository_url" {}

