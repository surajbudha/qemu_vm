###############################
# Resources
###############################

resource "libvirt_volume" "disk" {
  name      = "${var.vm_name}.qcow2"
  pool      = var.storage_pool
  format    = "qcow2"
  capacity  = var.disk_size
}

variable "storage_pool" {
  type        = string
  default     = "default"
  description = "Libvirt storage pool name"
}

resource "libvirt_domain" "vm" {
  depends_on = [libvirt_volume.disk]
  name   = var.vm_name
  memory = var.memory
  #unit = "MIB"
  vcpu   = var.cpus

  cpu = {
    mode = "host-passthrough"
  }

  os = {
    type    = "hvm"
    arch    = "x86_64"
    machine = "q35"
    boot_devices = ["cdrom", "hd", "network"]
  }

  devices = {
    #firmware = var.firmware
    disks = [ {
      device = "disk"
      source = {
        pool = var.storage_pool
        volume = "${var.vm_name}.qcow2"
      }
      target = {
        dev = "vda"
        bus = "virtio"
      }
      
    },
    {
      device = "cdrom"
      bootable = true
      source = {
        file = var.iso_url
      }
      target = {
        dev = "sda"
        bus = "sata"
      }
      readonly = true
    }]
    interfaces = [ {
      type = "network",
      model = "virtio"
      source = {
        network = "default"
      }
    } ]
    xml = {
        # Inject arbitrary QEMU args via domain XML
        xslt = <<EOF
    <xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

      <xsl:template match="/domain/qemu:commandline" xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0">
        <commandline xmlns="http://libvirt.org/schemas/domain/qemu/1.0">
          <xsl:for-each select="command">
            <xsl:copy-of select="."/>
          </xsl:for-each>
          <!-- Extra args from Terraform -->
          <xsl:for-each select="string-to-node-set('${join(" ", var.extra_args)}')">
            <arg value="{.}"/>
          </xsl:for-each>
        </commandline>
      </xsl:template>

    </xsl:stylesheet>
    EOF
    }
    graphics = {
      spice = {
        listen_type = "address"
        listen_address = "0.0.0.0"
        autoport = "yes",
      }
    }
    serials = [ {
      type = "pty"
      target_type = "isa-serial"
      target_port = "0"
    } ]
    video = {
      type = "virtio"
    }
  }
  
}


variable "network" {
  type        = string
  default     = "default"
  description = "Libvirt network name"
}

variable "firmware" {
  type        = string
  default     = null
  description = "Optional firmware override for UEFI (e.g., /usr/share/OVMF/OVMF_CODE.fd)"
}