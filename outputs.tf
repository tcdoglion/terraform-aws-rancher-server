output "sg" {
	value = "${aws_security_group.rancher_manager.id}"
}

output "elb_dns_name" {
	value = "${aws_elb.rancher_manager.dns_name}"
}

output "elb_zone_id" {
	value = "${aws_elb.rancher_manager.zone_id}"
}