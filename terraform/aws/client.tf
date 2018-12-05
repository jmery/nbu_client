resource "aws_instance" "nbu_client" {
  connection {
    user        = "centos"
    private_key = "${file("${var.aws_key_pair_file}")}"
  }

  ami                         = "${data.aws_ami.centos.id}"
  instance_type               = "t2.large"
  key_name                    = "${var.aws_key_pair_name}"
  subnet_id                   = "${aws_subnet.nbu-subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.base_linux.id}", "${aws_security_group.habitat_supervisor.id}", "${aws_security_group.nbu_client.id}"]
  associate_public_ip_address = true

  tags {
    Name          = "nbu_client_${random_id.instance_id.hex}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /etc/machine-id",
      "sudo systemd-machine-id-setup",
      "sudo hostname nbuclient"
    ]

    connection {
      host        = "${self.public_ip}"
      type        = "ssh"
      user        = "${var.aws_centos_image_user}"
      private_key = "${file("${var.aws_key_pair_file}")}"
    }
  }

  provisioner "habitat" {
    use_sudo     = true
    service_type = "systemd"

    connection {
      host        = "${self.public_ip}"
      type        = "ssh"
      user        = "${var.aws_centos_image_user}"
      private_key = "${file("${var.aws_key_pair_file}")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 20"
    ]

    connection {
      host        = "${self.public_ip}"
      type        = "ssh"
      user        = "${var.aws_centos_image_user}"
      private_key = "${file("${var.aws_key_pair_file}")}"
    }
  }

  provisioner "habitat" {
    use_sudo = true

    service {
      name = "jmery/nbu_client"
      channel = "stable"
      strategy = "at-once"
    }

    connection {
      host        = "${self.public_ip}"
      type        = "ssh"
      user        = "${var.aws_centos_image_user}"
      private_key = "${file("${var.aws_key_pair_file}")}"
    }
  }

}