provider "aws" {
  region = "eu-central-1"
}


resource "aws_instance" "example" {
  ami                    = "ami-0c115dbd34c69a004"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
echo "Hello World" > /var/www/html/index.html
sudo service httpd start
chkconfig on
EOF

  tags = {
    Name = "my-example"
  }
}

resource "aws_security_group" "instance" {
  name = "d"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "terraform" {
  bucket = "terraform-fhfh"

  versioning {
    enabled = true
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-fhfh"
    key    = "stage/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
  }
}


