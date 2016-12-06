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

resource "aws_security_group_rule" "rancher_manager_ingress_ipsec1" {
    type = "ingress"
    from_port = 500
    to_port = 500
    protocol = "udp" # UDP
    source_security_group_id = "${aws_security_group.rancher_manager.id}"
    security_group_id = "${aws_security_group.rancher_manager.id}"
}

resource "aws_security_group_rule" "rancher_manager_ingress_ipsec2" {
    type = "ingress"
    from_port = 4500
    to_port = 4500
    protocol = "udp" # UDP
    source_security_group_id = "${aws_security_group.rancher_manager.id}"
    security_group_id = "${aws_security_group.rancher_manager.id}"
}

resource "aws_security_group_rule" "rancher_manager_ha1" {
    type = "ingress"
    from_port = 9345
    to_port = 9345
    protocol = "tcp"
    source_security_group_id = "${aws_security_group.rancher_manager.id}"
    security_group_id = "${aws_security_group.rancher_manager.id}"
}

resource "aws_security_group_rule" "rancher_manager_icmp" {
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "icmp"
    source_security_group_id = "${aws_security_group.rancher_manager.id}"
    security_group_id = "${aws_security_group.rancher_manager.id}"
}

# NOTE:
# You need to make sure that port 18080 is open and available to the ELB.
# Currently, we are setting this in another module.
