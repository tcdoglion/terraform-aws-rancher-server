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

  listener {
    instance_port = 18080
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "ssl"
    ssl_certificate_id = "${var.elb_ssl_cert_id}"
  }

  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 5
    target = "HTTP:18080/ping"
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
