#!/bin/bash
set -e # Abort if there is an issue with any build.

project_folder="project"

addGitSubModule() {
  cd "$1"
  echo "Adding submodule $2"
  git submodule add https://github.com/lsampaioweb/$2.git "$3"
  cd -
}

addGitSubModules() {
  cd "$project_folder/$1"

  git init
  addGitSubModule "ansible/roles/" "ansible-common-tasks" "common"
  addGitSubModule "packer/" "packer-proxmox-ubuntu-22-04-clone" "clone"
  addGitSubModule "terraform/modules/" "terraform-proxmox-ubuntu-22-04-module" "proxmox-ubuntu-22-04"

  git submodule init
  # git pull --recurse-submodules
}

createFolderFromSkeleton() {
  mkdir -p "$project_folder"
  cp -a ".skeleton/." "$project_folder/$1"
}

createProject() {
  echo "Creating project '$1'."

  createFolderFromSkeleton "$1"

  addGitSubModules "$1"
}

userHasProvidedArguments () {
  # 0 True and 1 False
  [ $# -ge 1 ] && return 0 || return 1
}

if (userHasProvidedArguments $*) ; then
  createProject "$1"  
else
  echo "You have to inform the name of the project."
fi
