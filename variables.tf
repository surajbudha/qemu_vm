###############################
# Variables
###############################

variable "libvirt_uri" {
  description = "Connection URI for libvirt (e.g. qemu:///system)"
  type        = string
  default     = "qemu:///system"
}

variable "vm_name" {
  type        = string
  description = "Name of the VM to create"
}

variable "iso_url" {
  type        = string
  default = "/var/www/html/isos/Rocky-9.6-x86_64-minimal.iso"
  description = "URL of the ISO image to boot from"
}

variable "memory" {
  type        = number
  default     = 4194304
  description = "Memory size in KIB"
}

variable "cpus" {
  type        = number
  default     = 2
  description = "Number of CPU cores"
}

variable "disk_size" {
  type        = number
  default     = 21474836480
  description = "Disk size"
}

variable "extra_args" {
  type        = list(string)
  default     = []
  description = "Optional extra QEMU args passed through libvirt domain XML"
}