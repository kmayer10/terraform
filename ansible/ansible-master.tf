provider "aws" {
	region = "us-east-1"
}

# Creating CENTOS Server
resource "aws_instance" "ansible-master" {
	ami           	= 	"ami-030ff268bd7b4e8b5"
	instance_type 	= 	"t2.micro"
	count 			= 	1
	key_name		= "Kul-Thinknyx"
		
	tags = {
		Name 		= 	"ansible-master"
	}
	
	provisioner "remote-exec" {
	
		connection {
			type = "ssh"
			user = "root"
			password = "thinknyx@123"
			host = self.public_ip
		}
		inline = [
			"sudo yum install -y wget",
			"sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
			"sudo yum install -y ansible",
			"sudo echo 'host_key_checking = False' >> /etc/ansible/ansible.cfg"
		]
	}
	
	provisioner "local-exec" {
		command = "echo   > private_ip"
	}
	
	provisioner "local-exec" {
		command = "echo ${self.public_ip} >> private_ip"
	}
	
}