#provider "aws" "aws-2" {
	#region = "us-east-1"
#}

# Creating CENTOS Server
resource "aws_instance" "ansible-node" {
	ami           	= 	"ami-030ff268bd7b4e8b5"
	instance_type 	= 	"t2.micro"
	count 			= 	2
	key_name		= 	"Kul-Thinknyx"
		
	tags = {
		Name 		= 	"ansible-master"
	}
	
	provisioner "remote-exec" {
	
		connection {
			type = "ssh"
			user = "root"
			password = "thinknyx@123"
			host = aws_instance.ansible-master[count.index].public_ip
		}
		inline = [
			"echo ${self.public_ip} >> /etc/ansible/hosts"
		]
	}
	
}