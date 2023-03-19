
module "mybucket" {
  source      = "./modules/s3"
  bucket-name = "hello-k2jdk2l3884fh"
  tags = {
    description = "hello desc"
  }
  environment = terraform.workspace
}

module "lamb" {
  source      = "./modules/lambda-sqs"
  queue_name = "myq"
  function_name = "myf"
  environment = terraform.workspace
}