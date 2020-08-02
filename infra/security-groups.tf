resource "aws_security_group" "allow_all_vpc" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [module.vpc.vpc_cidr_block]
    ipv6_cidr_blocks = []
    self             = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
  }
}


resource "aws_security_group" "web_all_public" {
  vpc_id = module.vpc.vpc_id

  name_prefix = "web-all-public"

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "6"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "6"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
  }

  tags = {
    Name = "sgr-${var.fp_context}-web-all-public"
  }
}

resource "aws_security_group" "db" {
  vpc_id = module.vpc.vpc_id

  name = "allow-db"

  ingress {
    from_port        = 27017
    to_port          = 27017
    protocol         = "6"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
  }

  tags = {
    Name = "sgr-${var.fp_context}-db"
  }
}
