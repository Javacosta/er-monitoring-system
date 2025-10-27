# terraform/compute.tf

# Find the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create a security group for our server
resource "aws_security_group" "server_sg" {
  name        = "${var.name}-server-sg"
  description = "Allow SSH and App traffic"
  vpc_id      = aws_vpc.this.id # From network-core.tf

  tags = merge(local.tags, { Name = "${var.name}-server-sg" })

  # Ingress (Inbound) Rules
  ingress {
    description     = "Allow SSH from within the VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allow our App (port 8080) from within the VPC"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"] 
  }

  # Egress (Outbound) Rules
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the EC2 Instance
resource "aws_instance" "llama_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro" # Free tier eligible

  # Place it in the private subnet
  subnet_id = aws_subnet.public.id 
  associate_public_ip_address = true

  # Attach the security group
  vpc_security_group_ids = [aws_security_group.server_sg.id]

  # We need a key pair to be able to SSH in
  # Make sure you create a key pair in the AWS console
  # and name it "terraform-key" or change the name here.
  key_name = "terraform-key" 

  tags = merge(local.tags, { Name = "${var.name}-llama-server" })
}
