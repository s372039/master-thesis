resource "openstack_compute_instance_v2" "dev_server" {
  flavor_name = var.flavor
  key_pair = var.key_pair_name
  name = "dev_server"
  network {
    name = var.network
  }

  block_device {
    uuid = var.image_uuid
    source_type = "image"
    volume_size = var.volume_size
    boot_index = 0
    destination_type = "volume"
    delete_on_termination = false
  }

  provisioner "file" {
    source = "configuration_management/development_manifest.pp"
    destination = "/tmp/development_manifest.pp"
  }

  provisioner "file" {
    source = "configuration_management/automation_scripts/full_checkout_script.sh"
    destination = "/tmp/full_checkout_script.sh"
  }

  provisioner "file" {
    source = "configuration_management/automation_scripts/full_push_script.sh"
    destination = "/tmp/full_push_script.sh"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
    host = openstack_compute_instance_v2.dev_server.access_ip_v4
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 20",
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo apt -y install puppet",
      "sudo apt update",
      "sudo puppet module install puppetlabs-stdlib",
      "sudo puppet apply /tmp/development_manifest.pp"
    ]
  }
}
