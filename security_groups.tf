# Security Group (Manager / Server)
resource "aws_security_group" "rancher_manager" {
  name = "rancher-manager"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.rancher_server_name}"
    Environment = "${var.environment}"
    terraform = "true"
  }
}

resource "aws_security_group_rule" "rancher_manager_egress_allow_all" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.rancher_manager.id}"
}

