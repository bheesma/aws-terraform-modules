
module "mybucket" {
  source = "./modules/s3"
  bucket-name = "hello-2jdk2l3884fh"
}

module "mybucket2" {
  source = "./modules/s3"
  bucket-name = "hello-kjdk2l3884fh"
}