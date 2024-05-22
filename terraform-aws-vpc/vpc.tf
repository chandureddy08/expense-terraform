resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = var.enable_dns_hostnames

    tags = merge(
        var.common_tags,
        var.vpc_tags,
        {
      Name = local.resource_name
    }
    )
}

resource "aws_internet_gateway" "expense" {
    vpc_id = aws_vpc.main.id
    
    tags = merge(
        var.common_tags,
        var.igw_tags,
        {
            Name = local.resource_name
        }
    )
}

## PUBLIC SUBNET ##
resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    map_public_ip_on_launch = true
    availability_zone = local.az_names[count.index]
    cidr_block = var.public_subnet_cidrs[count.index]
    
    tags = merge(
        var.common_tags,
        var.public_subnet_cidrs_tags,
        {
            Name = "${local.resource_name}-public-${local.az_names[count.index]}"
        }
    )
}

## PRIVATE SUBNET ##
resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    availability_zone = local.az_names[count.index]
    cidr_block = var.private_subnet_cidrs[count.index]

    tags = merge(
        var.common_tags,
        var.private_subnet_cidrs_tags,
        {
            Name = "${local.resource_name}-private-${local.az_names[count.index]}"
        }
    )
}

## DATABASE SUBNET ##
resource "aws_subnet" "database" {
    count = length(var.database_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    availability_zone = local.az_names[count.index]
    cidr_block = var.database_subnet_cidrs[count.index]
    tags = merge(
        var.common_tags,
        var.database_subnet_cidrs_tags,
        {
            Name = "${local.resource_name}-database-${local.az_names[count.index]}"
        }
    )
}

## DATABASE SUBNET GROUP ##
resource "aws_db_subnet_group" "default" {
    name = local.resource_name
    subnet_ids = aws_subnet.database[*].id

    tags = merge(
        var.common_tags,
        var.aws_db_subnet_group_tags,
        {
            Name = local.resource_name
        }
    )
}

## ELASTIC IP ##
resource "aws_eip" "nat" {
    domain = "vpc"
}

## NAT GATEWAY ##
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public[0].id
    
    tags = merge(
        var.common_tags,
        var.nat_gateway_tags,
        {
            Name = local.resource_name
        }
    )
    depends_on = [ aws_internet_gateway.expense ]  # explicit dependency means first create IGW and then NAT
}

## PUBLIC ROUTE TABLE ##
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    
    tags = merge(
        var.common_tags,
        var.public_route_table_tags,
        {
            Name = "${local.resource_name}-public"
        }
    )
}

## PRIVATE ROUTE TABLE ##
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        var.private_route_table_tags,
        {
            Name = "${local.resource_name}-private"
        }
    )
}

## DATABASE ROUTE TABLE ##
resource "aws_route_table" "database" {
    vpc_id = aws_vpc.main.owner_id

    tags = merge(
        var.common_tags,
        var.database_route_table_tags,
        {
            Name = "${local.resource_name}-database"
        }
    )
}

## PUBLIC ROUTE ##
resource "aws_route" "public_route" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.expense.id
}

## PRIVATE ROUTE ##
resource "aws_route" "private_route_nat" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}

## DATABASE ROUTE ##
resource "aws_route" "database_route_nat" {
    route_table_id = aws_route_table.database.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}

## PUBLIC ASSOCIATION ##
resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidrs)
    subnet_id = element(aws_subnet.public[*].id, count.index)
    route_table_id = aws_route_table.public.id
}

## PRIVATE ASSOCIATION ##
resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidrs)
    subnet_id = element(aws_subnet.private[*].id, count.index)
    route_table_id = aws_route_table.private.id
}

## DATABASE ASSOCIATION ##
resource "aws_route_table_association" "database" {
    count = length(var.database_subnet_cidrs)
    subnet_id = element(aws_subnet.database[*].id, count.index)
    route_table_id = aws_route_table.database.id
}
