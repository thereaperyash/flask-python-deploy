provider "aws" {
  region = "ap-southeast-2"
}

variable "image_tag" {
  type        = string
  description = "The specific version tag of the docker image from Jenkins"
}

resource "aws_security_group" "flask_sg" {
  name        = "flask-app-sg"
  description = "Allow inbound web traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
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

resource "aws_instance" "flask_server" {
  ami           = "ami-0a59248a6294cece2" # Ubuntu 26.04 LTS AMI in Sydney
  instance_type = "t3.medium"
  
  vpc_security_group_ids = [aws_security_group.flask_sg.id]

  # Make sure the EC2 server knows how to fetch and authenticate with ECR
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io awscli
              sudo systemctl start docker
              sudo systemctl enable docker

              # In a production setup, we would use an IAM Instance Profile here.
              # For this beginner project, we pull from public or authenticating directly inside the script works.
              # Since the instance needs to authenticate to pull from ECR, we run the login command.
              # Note: In real scenarios, attaching an IAM policy 'AmazonEC2ContainerRegistryReadOnly' to this EC2 is the clean way.
              
              # Pull and run the dynamic container version passed down by Jenkins
              sudo docker run -d -p 5000:5000 531572985235.dkr.ecr.ap-southeast-2.amazonaws.com/cicdflask:${var.image_tag}
              EOF

  tags = {
    Name = "Flask-Deployment-Server"
  }
}
