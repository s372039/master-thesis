variable "key_pair_name" {
  description = "Name of ssh keypair to use that exist in the project"
  type = string
  default = "masterkey"
}

variable "flavor" {
  description = "Openstack instance flavor"
  type        = string
  default     = "csh.2c4r"
}

variable "network" {
  description = "Openstack network name"
  type = string
  default = "acit"
}

variable "image_uuid" {
  description = "UUID of Openstack image"
  type = string
  default = "12ac2bc8-1ffb-46af-87dc-adb5219b0b3b"
}

variable "volume_size" {
  description = "Volume size"
  type = number
  default = 10
}
