#!/bin/bash
curDir=$PWD
west="us-west-2.tfvars"
east="us-east-2.tfvars"

function usage {
  echo -e "Usage: t [options...]
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
  -h  view usage"
  exit 
}

function workspace {
  case "$1" in
    -wc)
     terraform workspace new $2
     exit
     ;;
    -wd)
     terraform workspace delete $2
     exit
     ;;
    -wl)
     terraform workspace list
     exit
     ;;
    -ws)
     terraform workspace select $2
     exit
     ;;
  esac
}

case "$1" in
  -p)
   execType="plan"
   noVars="true"
   ;;
  -pw)
   execType="plan"
   fileName=$west
   ;;
  -pe)
   execType="plan"
   fileName=$east
   ;;
  -a)
   execType="apply"
   noVars="true"
   ;;
  -aw)
   execType="apply"
   fileName=$west
   ;;
  -ae)
   execType="apply"
   fileName=$east
   ;;
  -i)
   execType="init"
   ;;
  -iu)
   execType="init --upgrade"
   ;;
  -id)
   execType="init"
   rmCmd="rm -rf .terraform"
   ;;
  -w[cdls])
   workspace $1 $2
   ;;
  *)
   usage
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
exit 1
