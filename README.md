# tf-wrapper

This simple bash script will auto-locate the tfvars file when running plans and applies

## Usage
```
Usage: t [options...]
Options:
  -i  init
  -iu init --upgrade
  -id delete .terraform dir and run an init
  -p  plan with NO vars file
  -pw plan using us-west-2 vars file
  -pe plan using us-east-2 vars file
  -a  apply with NO vars file
  -aw apply using us-west-2 vars file
  -ae apply using us-east-2 vars file
  -wc create new workspace
  -wd delete workspace
  -wl list workspaces
  -ws select workspace
  -h  view usage
```

You may also pass arbitrary terraform arguments to the script.

```
Example:
t -pw -target=module.create_ec2_instance
```
