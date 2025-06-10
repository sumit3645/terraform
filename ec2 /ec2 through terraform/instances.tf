#creating ssh-key for instances
resource "aws_key_pair" "key_tf" {
  key_name   = "sumit-key"
  public_key = file("${path.module}/id_rsa.pub")
}

#create a secutity_group 
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  dynamic "ingress"{
    for_each=[22,80,443,3306]
    iterator=port
    content {
    description="TLS from vpc"
    from_port=port.value
    to_port=port.value
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
    }
  }
}



#create instances and attach ssh-key and sg to instances
resource "aws_instance" "app-server" {
  ami           = "ami-02521d90e7410d9f0"
  instance_type = "t2.micro"
  key_name="${aws_key_pair.key_tf.key_name}"
  vpc_security_group_ids=["${aws_security_group.allow_tls.id}"]
  tags = {
    Name = "terraform-demo"
  }
}
