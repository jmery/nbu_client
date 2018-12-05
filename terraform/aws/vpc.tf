resource "aws_vpc" "nbu-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name          = "${var.tag_name}-vpc"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Contact     = "${var.tag_contact}"
    X-Application = "${var.tag_application}"
    X-TTL         = "${var.tag_ttl}"
  }
}

resource "aws_internet_gateway" "nbu-gateway" {
  vpc_id = "${aws_vpc.nbu-vpc.id}"

  tags {
    Name = "nbu-gateway"
  }
}

resource "aws_route" "nbu-internet-access" {
  route_table_id         = "${aws_vpc.nbu-vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.nbu-gateway.id}"
}

resource "aws_subnet" "nbu-subnet" {
  vpc_id                  = "${aws_vpc.nbu-vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "nbu-subnet"
  }
}
