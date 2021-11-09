variable "folder_id" {
  description = "наследуем из корня"
  type        = string
}

variable "yc_token" {
  description = "наследуем из корня"
  type        = string
}

variable "vpc_subnet" {
  description = "наследуем из корня"
  type        = string
}

variable "user" {
  type = string
  default = "yc-user"
}

variable "password" {
  type = string
  default = "12345"
}

variable "public_key_path" {
  description = "Path to ssh public key, which would be used to access workers"
  default     = "/mnt/c/Users/root/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to ssh private key, which would be used to access workers"
  default     = "/mnt/c/Users/root/.ssh/id_rsa"
}
