
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.aws_owners] # ID officiel du compte Canonical (Ubuntu)
}

# create a VPC for the web server
# This VPC will be used to host the web server instances
resource "aws_vpc" "mon_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "web-server-vpc"
  }
}

# create a subnet for the web server
# This subnet will be used to host the web server instances
resource "aws_subnet" "mon_subnet" {
  vpc_id            = aws_vpc.mon_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "web-server-subnet"
  }
}

# create a security group for the web server
# This security group will allow HTTP traffic on port 8080
resource "aws_security_group" "web_sg" {
  name = "web-server-sg"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# create an EC2 instance for the web server
# This instance will run Apache and serve a simple HTML page
resource "aws_instance" "serveur-web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              sed -i -e 's/80/8080/' /etc/apache2/ports.conf
              currentDateTime=$(date)
              echo "<html><body><h1>Welcome to the Web Server!</h1><p>Current Date and Time: $currentDateTime</p></body></html>" > /var/www/html/index.html
              systemctl restart apache2
              EOF

  tags = {
    Name = "web-server"
  }
}