
#Create a VPC.
resource "huaweicloud_vpc" "terra_vpc" {
  name = "terraform_vpc"
  cidr = "192.168.0.0/16"
}
#Create a Subnet within the VPC
resource "huaweicloud_vpc_subnet_v1" "subnet_v1" {
  name       = "subnet-terraform"
  cidr       = "192.168.0.0/24"
  gateway_ip = "192.168.0.1"
  vpc_id     = huaweicloud_vpc.terra_vpc.id
}

# Create Security Group and rule ssh
resource "huaweicloud_networking_secgroup_v2" "secgroup_1" {
  name        = "secgroup_terraform"
  description = "terra security group"
}

resource "huaweicloud_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup_v2.secgroup_1.id
}

# Create ECS
resource "huaweicloud_compute_instance" "basic" {
  name              = "basic"
  image_name        = "Ubuntu 18.04 server 64bit"
  flavor_name       = "t6.small.1"
  key_pair          = "KeyPair-terraform"
  security_groups   = [huaweicloud_networking_secgroup_v2.secgroup_1.name]
  availability_zone = "${var.region_az}a"

  network {
  uuid = huaweicloud_vpc_subnet_v1.subnet_v1.id
  }
}

#Binding an EIP

resource "huaweicloud_vpc_eip" "myeip" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "mybandwidth"
    size        = 8
    share_type  = "PER"
    charge_mode = "traffic"
  }
}
resource "huaweicloud_compute_eip_associate" "associated" {
  public_ip   = huaweicloud_vpc_eip.myeip.address
  instance_id = huaweicloud_compute_instance.basic.id
}