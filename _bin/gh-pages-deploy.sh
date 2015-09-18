#!/bin/bash

function jekyll-build() {
  local build_directory=$1
  #local source_folder=${BASH_SOURCE%/*}
  #echo $(readlink -m $source_folder)

  jekyll build -d ${build_directory}
}

function fetch-latest() {
  local temporary_directory=$1
  git clone git@github.com:Irkka/dml-website $temporary_directory
}

function prime-git-branch() {
  local temporary_directory=$1

  fetch-latest $temporary_directory
  # create a subshell and switch to orphan branch gh-pages
  ( cd $temporary_directory && git checkout --orphan gh-pages )
}

function commit-and-push() {
  local temporary_directory
  ( cd $temporary_directory && git add -A && git commit -m "DML website Jekyll build @$(date +%F-%T)" && git push origin gh-pages:gh-pages )
}

temporary_directory=$(mktemp -d _gh-pages-deploy-XXXXXXXXXXXX)
trap "rm -rf ${temporary_directory}" EXIT

prime-git-branch $temporary_directory
jekyll-build $temporary_directory
commit-and-push $temporary_directory
