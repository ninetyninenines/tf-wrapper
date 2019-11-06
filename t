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
  "-i")
    execType="init"
    ;;
  "-iu")
    execType="init --upgrade"
    ;;
  "-id")
    execType="init"
    rmCmd="rm -rf .terraform"
    ;;
  *)
    echo -e "Usage: t [options...]
Options:
  -i  Run a terraform init
  -iu Run a terraform init --upgrade
  -id Delete .terraform dir and run a terraform init
  -pw Run terraform plan using us-west-2 vars file
  -pe Run terraform plan using us-east-2 vars file
  -aw Run terraform apply using us-west-2 vars file
  -ae Run terraform apply using us-east-2 vars file
  -h  View usage"
    exit 1
    ;;
esac

curDir=$PWD

if [ -z ${fileName+x} ]; then
  if [ ${rmCmd+x} ]; then
    echo "$rmCmd && terraform $execType ${@:2}"
    $rmCmd && terraform $execType ${@:2}
    exit
  else
    echo "terraform $execType ${@:2}"
    terraform $execType ${@:2}
    exit
  fi
else
  for i in {0..5}; do
    varFile=`find "$curDir" -maxdepth 1 -name "$fileName" | head -n1`
    if [ ${#varFile} -gt 0 ]
    then
      echo "terraform $execType -var-file=$varFile"
      terraform $execType -var-file=$varFile ${@:2}
      exit
    else
      curDir="${curDir}/.."
    fi
  done
fi

echo "ERROR: I traversed up 5 dir levels and never found a var file. You in the right place??"
