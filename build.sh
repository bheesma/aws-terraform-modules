terraform workspace select dev || terraform workspace new dev
terraform plan -var 'environment=dev' -out=tf.json
terraform apply "tf.json"
