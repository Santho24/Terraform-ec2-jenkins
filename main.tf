provider "aws" {
  region = var.aws_region
}

data "template_file" "user_data" {
template = "${file("./userdata.sh")}"
}

resource "aws_instance" "Instance-2" {
  ami = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${var.security_group}"]

  tags= {
    Name = "jenkins_instance-new"
  }
  user_data = "${data.template_file.user_data.rendered}"
}

output "jenkins_endpoint" {
  value = formatlist("http://%s:%s/", aws_instance.Instance-2.*.public_ip, "8080")
}