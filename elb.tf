# ELB
resource "aws_elb" "rancher_manager" {
  name = "${var.rancher_server_name}"
  subnets = ["${var.elb_subnet_1_id}"]
  internal = "${var.elb_is_internal}"
  security_groups = ["${var.elb_sg_id}"]

  access_logs {
     bucket = "${var.elb_logs_bucket}"
     bucket_prefix = "elb"
     interval = 60
  }

  # listener {
  #   instance_port = 80
  #   instance_protocol = "http"
  #   lb_port = 80
  #   lb_protocol = "http"
  # }

# listener port used to be 81 
# chagned on Sep-15-2016
# for single node, use 8080. 
#
  listener {
    instance_port = 8080
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "ssl"
    ssl_certificate_id = "${var.elb_ssl_cert_id}"
  }

  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 5
# -- for ha
#    target = "HTTP:18080/ping"

# for single node
    target = "HTTP:8080/ping"
    interval = 6
  }

  tags {
    Name = "${var.rancher_server_name}"
    Environment = "${var.environment}"
    terraform = "true"
  }
}

# ELB Proxy Policy
# This is needed to enable websockets
# http://docs.rancher.com/rancher/installing-rancher/installing-server/basic-ssl-config/#running-rancher-server-behind-an-elb-in-aws-with-ssl
resource "aws_proxy_protocol_policy" "http_alt" {
  load_balancer = "${aws_elb.rancher_manager.name}"
  instance_ports = ["8080"]
}
resource "aws_proxy_protocol_policy" "http_alt2" {
  load_balancer = "${aws_elb.rancher_manager.name}"
  instance_ports = ["18080"]
}
resource "aws_proxy_protocol_policy" "http_alt3" {
  load_balancer = "${aws_elb.rancher_manager.name}"
  instance_ports = ["81"]
}
resource "aws_proxy_protocol_policy" "http_alt4" {
  load_balancer = "${aws_elb.rancher_manager.name}"
  instance_ports = ["444"]
}
