provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_instance" "hello_world" {
    ami = "ami-fce3c696"  # Ubuntu 14.04 for us-east-1
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.web.id}"]
    key_name = "${aws_key_pair.hello_world.id}"
}

resource "aws_security_group" "web" {
    name = "web"
    description = "Allow HTTP and SSH connections."

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

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

resource "aws_key_pair" "hello_world" {
    key_name = "hello_world"
    public_key = "${file(var.public_key_path)}"
}
