variable "project_name" { type = string  default = "hello-eks" }
variable "region"       { type = string  default = "ap-south-1" }
variable "min_size"     { type = number  default = 1 }
variable "max_size"     { type = number  default = 1 }
variable "instance_type"{ type = string  default = "t3.micro" }
