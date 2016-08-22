# Autoscale Group

# Variables
variable "userdata_template" {
  type = "string"
  default = "userdata.template"
}

variable "rancher_manager_min_size" {
  type = "string"
  default = "1"
}

variable "rancher_manager_max_size" {
  type = "string"
  default = "1"
}

# Rancher Manager
resource "aws_autoscaling_group" "rancher_manager" {
  name = "${var.rancher_server_name}"
  min_size = "${var.rancher_manager_min_size}"
  max_size = "${var.rancher_manager_max_size}"
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.rancher_manager.name}"
  load_balancers = ["${aws_elb.rancher_manager.name}"]
  termination_policies  = ["OldestLaunchConfiguration", "OldestInstance"]
  vpc_zone_identifier = ["${var.ec2_subnet_1_id}"]

  tag {
    key = "Environment"
    value = "${var.environment}"
    propagate_at_launch = true
  }
  tag {
    key = "Name"
    value = "${var.rancher_server_name}"
    propagate_at_launch = true
  }
  tag {
    key = "Rancher"
    value = "server"
    propagate_at_launch = true
  }
  tag {
    key = "terraform"
    value = "true"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }

}

# Launch config
resource "aws_launch_configuration" "rancher_manager" {
  name_prefix = "${var.rancher_server_name}-"
  image_id = "${var.ec2_image_id}"
  instance_type = "${var.ec2_instance_type}"
  key_name = "${var.ec2_key_name}"
  security_groups = ["${var.ec2_sg_id}","${aws_security_group.rancher_manager.id}"]
  user_data = "${template_file.user_data.rendered}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.ec2_root_vol_size}"
    delete_on_termination = "${var.ec2_root_vol_delete}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# User-data template
resource "template_file" "user_data" {

  template = "${file("${path.module}/files/${var.userdata_template}")}"

  vars {
    docker_img_tag    = "${var.docker_img_tag}"

    # Database
    database_host     = "${var.database_host}"
    database_port     = "${var.database_port}"
    database_name     = "${var.database_name}"
    database_username = "${var.database_username}"
    database_password = "${var.database_password}"

  }

  lifecycle {
    create_before_destroy = true
  }

}
