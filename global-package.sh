#!/bin/bash

function readFromFile {
  input="./global-package.json"
  allModules=()

  # read from file 'input'
  while IFS= read -r var
  do
    allModules+=( $var )
  done < "$input"

  # create string to run.
  npmInstall="npm install"
  for idx in ${!allModules[@]}
  do 
    if [ "$idx" -gt 0 ] && [ "${allModules[$idx]}" != "+--" ] && [ "${allModules[$idx]}" != "\`--" ];then
      IFS='@' read -r -a splitStringArray <<< "${allModules[$idx]}"
      npmInstall="$npmInstall ${splitStringArray[0]}"
    fi
  done

  echo $npmInstall
}

function writeToFile {
  input="./global-package.json"
  eval "npm list -g --depth 0 > $input"
  echo "Written to file ./global-package.json"
}

if [ $# -eq 0 ]; then
  readFromFile
elif [ "$1" == "-w" ]; then
  writeToFile
else
  echo "Usage: ./npm-global \[options\] options: -w: write global package configuration to ./global-package.json"
fi 
