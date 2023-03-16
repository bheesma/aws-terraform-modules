
module "mybucket" {
  source      = "./modules/s3"
  bucket-name = "hello-k2jdk2l3884fh"
  tags = {
    description = "hello desc"
  }
}

module "mybucket2" {
  source      = "./modules/s3"
  bucket-name = "hello-bkjdk2l3884fh"
}

module "lamb" {
  source      = "./modules/lambda-sqs"
  queue-name = "myq"
  function-name = "myf"
}