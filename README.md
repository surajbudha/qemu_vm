###############################
# README Template
###############################

# README.md
# This module creates a VM using the libvirt provider with optional
# QEMU argument overrides, ISO booting, configurable storage pool,
# and UEFI firmware support.

# Example usage:
# module "example" {
#   source      = "../modules/qemu-libvirt"
#   vm_name     = "testvm"
#   iso_url     = "http://example.com/installer.iso"
#   memory      = 4096
#   cpus        = 4
#   extra_args  = ["-cpu host", "-smp 4"]
# }
