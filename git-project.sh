#!/bin/bash
set -e # Abort if there is an issue with any build.

project_folder="project"
github_url="https://github.com/lsampaioweb"

gitCommitAndPush() {
  git add .
  git commit -m "First commit" --author "Bot<lsampaioweb+bot@gmail.com>"
  git branch -M main
  git remote add origin "$github_url/$1.git"
  git push -u origin main
}

addGitSubModule() {
  cd "$1"
  echo "Adding submodule $2"
  git submodule add "$github_url/$2.git" "$3"
  cd -
}

addGitSubModules() {
  cd "$project_folder/$1"

  git init

  # Ansible.
  addGitSubModule "ansible/roles/" "ansible-common-tasks" "common"
  addGitSubModule "ansible/roles/" "ansible-kvm-cloud-init" "kvm_setup"

  # Packer.
  addGitSubModule "packer/" "packer-proxmox-ubuntu-22-04-clone" "clone"
  git submodule init
}

createFolderFromSkeleton() {
  mkdir -p "$project_folder"

  cp -a ".skeleton/." "$project_folder/$1"
}

createProject() {
  echo "Creating project '$1'."

  createFolderFromSkeleton "$1"

  addGitSubModules "$1"

  gitCommitAndPush "$1"
}

userHasProvidedArguments () {
  # 0 True and 1 False
  [ $# -ge 1 ] && return 0 || return 1
}

if (userHasProvidedArguments $*) ; then
  createProject "$1"
else
  echo "You have to inform the name of the project. e.g.: ./git-project.sh <project-name>"
fi
