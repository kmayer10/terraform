#$ export AWS_ACCESS_KEY_ID="anaccesskey"
#$ export AWS_SECRET_ACCESS_KEY="asecretkey"
#$ export AWS_DEFAULT_REGION="us-west-2"

#Configuring Provider
provider "aws" {
	region = var.aws_region
}

#AWS_SHARED_CREDENTIALS_FILE ## Variable defined for AWS Credentials # Default location is $HOME_DIR/.aws/credentials

resource "aws_security_group" "security_group" {
  name        = var.ID
  description = "Allow TLS inbound traffic"
  #vpc_id      = aws_vpc.main.id
  
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.ID
  }
}

resource "aws_ebs_volume" "volume" {
  availability_zone = var.availability_zone
  size              = 10
  count				= var.instance_count
  tags = {
    Name = var.ID
  }
}

# Creating CENTOS Server
resource "aws_instance" "centos" {
	ami           = "ami-030ff268bd7b4e8b5"
	instance_type = var.instance_type
	availability_zone = var.availability_zone
	
	count = var.instance_count
	
	security_groups = [
              aws_security_group.security_group.name
            ]
	
	tags = {
		Name = "Terraform-Demo"
		Environment = "Production"
	}
	
	provisioner "remote-exec" {
#    connection {
      #type        = "ssh"
      #user        = "root"
      #password    = "thinknyx@123"
      #host        = "${self.public_ip}"
    #}

    #inline = [
      #"sudo yum -y install httpd",
      #"sudo echo 'Hello and welcome to DevOps in Action Conference' > /var/www/html/index.html",
      #"sudo systemctl start httpd"
    #]
  #}
	
}

resource "aws_volume_attachment" "myserverebsattch" {
  count = var.instance_count
  device_name = "/dev/sdf"
  volume_id = aws_ebs_volume.volume[count.index].id
  instance_id = aws_instance.centos[count.index].id
}