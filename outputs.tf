###############################
# Outputs
###############################

output "vm_name" {
  value = libvirt_domain.vm.name
}

output "disk_image" {
  value = libvirt_volume.disk.name
}
