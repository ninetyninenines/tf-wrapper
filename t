#!/bin/bash
case "$1" in
  "-pw")
    execType="plan"
    fileName="us-west-2.tfvars"
    ;;
  "-pe")
    execType="plan"
    fileName="us-east-2.tfvars"
    ;;
  "-aw")
    execType="apply"
    fileName="us-west-2.tfvars"
    ;;
  "-ae")
    execType="apply"
    fileName="us-east-2.tfvars"
    ;;
  *)
    echo -e "Usage: t [options...]
Options:
  -pw Run terraform plan using us-west-2 vars file
  -pe Run terraform plan using us-east-2 vars file
  -aw Run terraform apply using us-west-2 vars file
  -ae Run terraform apply using us-east-2 vars file
  -h  View usage"
    exit 1
    ;;
esac

curDir=$PWD

for i in {0..5}; do
  varFile=`find "$curDir" -maxdepth 1 -name "$fileName" | head -n1`
  if [ ${#varFile} -gt 0 ]
  then
    echo "terraform $execType -var-file=$varFile"
    terraform $execType -var-file=$varFile
    exit
  else
    curDir="${curDir}/.."
  fi
done

echo "ERROR: I traversed up 5 dir levels and never found a var file. You in the right place??"
