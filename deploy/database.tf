resource "aws_db_subnet_group" "main" {
  name = "${local.prefix}-main"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = merge(
    local.common_tags,
    map("Name", "${local.prefix}-main")
  )
}

resource "aws_security_group" "rds" {
  name        = "${local.prefix}-rds-inbound-access"
  description = "Allow access to the RDS database instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    security_groups = [
      aws_security_group.bastion.id,
      aws_security_group.ecs_service.id,
    ]
  }

  tags = local.common_tags
}

resource "aws_db_instance" "main" {
  identifier              = "${local.prefix}-db"
  name                    = "recipe"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "11.15"
  instance_class          = "db.t2.micro"
  username                = var.db_username
  password                = var.db_password
  backup_retention_period = 0
  multi_az                = false
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_subnet_group_name    = aws_db_subnet_group.main.name

  tags = merge(
    local.common_tags,
    map("Name", "${local.prefix}-main")
  )
}
