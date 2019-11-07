#!/bin/bash
curDir=$PWD
west="us-west-2.tfvars"
east="us-east-2.tfvars"

case "$1" in
  "-p")
    execType="plan"
    noVars="true"
    ;;
  "-pw")
    execType="plan"
    fileName=$west
    ;;
  "-pe")
    execType="plan"
    fileName=$east
    ;;
  "-a")
    execType="apply"
    noVars="true"
    ;;
  "-aw")
    execType="apply"
    fileName=$west
    ;;
  "-ae")
    execType="apply"
    fileName=$east
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
    exit 1
    ;;
esac

if [ -z ${fileName+x} ]; then
  if [ ${rmCmd+x} ]; then
    echo "$rmCmd && terraform $execType ${@:2}"
    $rmCmd && terraform $execType ${@:2}
    exit
  elif [ ${rmCmd+x} ]; then
    echo "$terraform $execType ${@:2}"
    terraform $execType ${@:2}
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

echo "ERROR: Traversed up 5 dir levels and found no tfvars file named $fileName"
