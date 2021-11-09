data "yandex_compute_image" "ubuntu-20-04" {
family = "ubuntu-2004-lts"
}

data "template_file" "cloud_init" {
  template = file("mgmt/services/jenkins/meta.txt")
  vars = {
    user = var.user
    ssh_key = file(var.public_key_path)
  }
}

resource "yandex_compute_instance" "vm-1" {
  name = "jenkins"
  boot_disk {
    mode = "READ_WRITE"
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-20-04.id
    }
  }
  network_interface {
    subnet_id =  var.vpc_subnet
    nat       = true
  }
  resources {
    core_fraction = 20
    cores  = 2
    memory = 4
  }
  metadata = {
    user-data = data.template_file.cloud_init.rendered
    serial-port-enable = 1
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${var.user}:${var.password}' | sudo chpasswd",
      "sudo apt-get update",
      "sudo apt update",
      "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt update",
      "sudo apt install default-jre -y",
      "sudo apt install jenkins -y",
      "sudo systemctl start jenkins",
      "sleep 20",
      "curl -kv 0.0.0.0:8080",
      "echo ### PASSWORD!!!!! ####",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    ]
    connection {
      type = "ssh"
      user = var.user
      private_key = file(var.private_key_path)
      host = self.network_interface[0].nat_ip_address
    }
  }

  depends_on = [
    var.vpc_subnet
  ]

  timeouts {
    create = "10m"
  }
}