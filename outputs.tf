output "id_vpc" {
    value = aws_vpc.clc_vpc.id
}

output "public_subnet_1a" {
    value = aws_subnet.public_subnet_1a.id
}