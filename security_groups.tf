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

resource "aws_security_group_rule" "rancher_manager_ingress_zk1" {
    type = "ingress"
    from_port = 2888
    to_port = 2888
    protocol = "tcp"
    security_group = "${aws_security_group.rancher_manager.id}"
    security_group_id = "${aws_security_group.rancher_manager.id}"
}

resource "aws_security_group_rule" "rancher_manager_ingress_zk2" {
    type = "ingress"
    from_port = 2181
    to_port = 2181
    protocol = "tcp"
    security_group = "${aws_security_group.rancher_manager.id}"
    security_group_id = "${aws_security_group.rancher_manager.id}"
}

resource "aws_security_group_rule" "rancher_manager_ingress_zk3" {
    type = "ingress"
    from_port = 2376
    to_port = 2376
    protocol = "tcp"
    security_group = "${aws_security_group.rancher_manager.id}"
    security_group_id = "${aws_security_group.rancher_manager.id}"
}

resource "aws_security_group_rule" "rancher_manager_ingress_zk4" {
    type = "ingress"
    from_port = 3888
    to_port = 3888
    protocol = "tcp"
    security_group = "${aws_security_group.rancher_manager.id}"
    security_group_id = "${aws_security_group.rancher_manager.id}"
}

resource "aws_security_group_rule" "rancher_manager_ingress_zk5" {
    type = "ingress"
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    security_group = "${aws_security_group.rancher_manager.id}"
    security_group_id = "${aws_security_group.rancher_manager.id}"
}
