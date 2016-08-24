variable "environment" {}

variable "vpc_id" {}

variable "rancher_server_name" {
	default = "rancher-manager"
	description = "Used to tag EC2 instances"
}

# ELB Vars
variable "elb_logs_bucket" {
	description = "The S3 bucket where ELB logs should be written to."
}
variable "elb_is_internal" {
	default = true
	description = "Boolean. Set to false if this should be an external ELB. Defaults to true."
}
variable "elb_ssl_cert_id" {}
variable "elb_sg_id" {
	description = "Additional security groups to use on the Rancher ELB"
}
variable "elb_subnet_1_id" {}

# EC2 Vars
variable "ec2_image_id" {}
variable "ec2_instance_type" {}
variable "ec2_root_vol_size" {
	default = "40"
	description = "the size, in GB, of the root block device."
}
variable "ec2_root_vol_delete" {
	default = "true"
	description = "Set to false to disable the root volume from being deleted when the EC2 instance is terminated. Defaults to true."
}
variable "ec2_key_name" {}
variable "ec2_sg_id" {
	description = "Additional security groups to use on the Rancher server"
}
variable "ec2_subnet_1_id" {}


variable "docker_img_tag" {
	default = "latest"
}

# DB Vars
variable "database_host" {}
variable "database_port" {
	default = 3306
}
variable "database_name" {}
variable "database_username" {}
variable "database_password" {}

# ASG Vars
variable "userdata_template" {
  default = "userdata.template"
}
variable "cluster_size" {
  default = "3"
}
variable "cluster_min_size" {
  default = "0"
}
variable "cluster_max_size" {
  default = "5"
}
variable "host_registration_url" {
  default = ""
}
variable "encryption_key" {
  default = ""
}
