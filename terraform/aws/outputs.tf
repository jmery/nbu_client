output "vpc_id" {
  value = "${aws_vpc.nbu-vpc.id}"
}

output "subnet_id" {
  value = "${aws_subnet.nbu-subnet.id}"
}

output "client_ip" {
  value = "${aws_instance.nbu_client.public_ip}"
}