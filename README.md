# tf-wrapper

This simple bash script will auto-locate the tfvars file when running plans and applies

## Usage
```
Usage: t [options...]
Options:
  -i  terraform init
  -iu terraform init --upgrade
  -id Delete .terraform dir and run a terraform init
  -p  terraform plan with NO vars file
  -pw terraform plan using us-west-2 vars file
  -pe terraform plan using us-east-2 vars file
  -a  terraform apply with NO vars file
  -aw terraform apply using us-west-2 vars file
  -ae terraform apply using us-east-2 vars file
  -h  View usage"
```

You may also pass arbitrary terraform arguments to the script.
Example:
```t -pw -target=module.create_ec2_instance```
