variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  default     = "AKIAYSPYNASI54JHXL3C"
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  default     = "VMesYqgi+pmNpwsaViQfqso8bXuBjw1W5N8l0TYx"
}

variable "ssh_key_name" {
  description = "ssh key name"
  type        = string
  default     = "tf_key"
}

variable "private_key_path" {
  description = "private ssh key path"
  type        = string
  default     = "tf_key.pem"
}

variable "region" {
  default = "us-east-2"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "subnet1_cidr" {
  default = "172.16.0.0/24"
}
