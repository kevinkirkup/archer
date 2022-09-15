#!/usr/bin/env bash
# Purpose: Helper scripts and functions for working with Mercury
#
# Instructions: Just source this in to your current shell environment
#
# $ source envsetup.sh

##################################################
# Function to print the help for shell scripts
##################################################
function cHelp () {

  cat <<EOF
Invoke ". envsetup.sh" from your shell to add the following functions to your environment
- r              Run Iex command line
- f              Build firmware
- b              Burn the firmware image
- i              Build the firmware image
- dt             Run the developer tests
- ct             Run the CI/CD tests
- m              Build the code
- c              Run check
- cl             Run clean

Tooling:
- deps           Install the development environment

Developer:
- croot          Changes directory to the top of the tree
- godir          Go to the directory containing the specified file.
- pgrep          Grep for python files
- resgrep        Grep for resource files

- cHelp          Display this help message

EOF
}

##################################################
# Function to get to the top of the build tree
##################################################
alias croot='cd $(gettop)'
function gettop() {
  git rev-parse --show-toplevel
}

##################################################
# Execute the specify function at the top of the tree
##################################################
function at_top() {

  T=$(gettop)

  local HERE=`pwd`

  # Go to the top of the build tree
  if [ -d "$T" ]; then

    cd $T

    echo $1
    bash -c $1

    cd $HERE
  else
    echo "Couldn't locate the top of the tree. Try setting TOP."
  fi

}

#--------------------------------------------------
# Function to go to the directory containing the
# specified file
#--------------------------------------------------
function godir() {

  # Check to make sure a correct argument was provided
  if [[ -z "$1" ]]; then
    echo "Usage: godir <regex>"
    return
  fi

  # Make the index if it doesn't exist
  T=$(gettop)
  if [[ ! -f $T/filelist ]]; then
    echo -n "Creating index..."
    (cd $T; find -E . -type f -iregex '.*\.(go|yml|sh)' > filelist)
    echo " Done"
    echo ""
  fi

  # Get the list of files from the index
  local lines
  lines=($(grep "$1" $T/filelist | sed -e 's/\/[^/]*$//' | sort | uniq))
  if [[ ${#lines[@]} = 0 ]]; then
    echo "Not found"
    return
  fi

  # Create a menu based on the file list
  local pathname
  local choice

  if [[ ${#lines[@]} > 1 ]]; then
    while [[ -z "$pathname" ]]; do
      local index=1
      local line
      for line in ${lines[@]}; do
        printf "%6s %s\n" "[$index]" $line
        index=$((index + 1))
      done
      echo
      echo -n "Select one: "
      unset choice
      read choice
      if [[ $choice -gt ${#lines[@]} || $choice -lt 1 ]]; then
        echo "Invalid choice"
        continue
      fi

      pathname=${lines[$choice]}
    done
  else
    pathname=${lines[1]}
  fi

  cd $T/$pathname
}

##################################################
# Function to grep all of the Go files in the
# current sub-directory
##################################################
function egrep() {
  find . -type f \( -name '*.ex' -name '*.exs' \) -print0 | xargs -0 rg -n "$@"
}

##################################################
# Function to grep all of the *.yml files in the
# current sub-directory
##################################################
function resgrep() {
  find . -type f \( -name '*.yml' -name '*.json' \) -print0 | xargs -0 rg -n "$@"
}

#--------------------------------------------------
# Install build dependencies
#--------------------------------------------------
function deps() {
  at_top 'mix deps.get && mix deps.compile'
}

#--------------------------------------------------
# Run with Iex
#--------------------------------------------------
function r() {
  at_top 'iex -S mix'
}

#--------------------------------------------------
# Build the firmware
#--------------------------------------------------
function f() {
  at_top 'mix firmware'
}

#--------------------------------------------------
# Build the firmware bundle and writ it to the SDCard
#--------------------------------------------------
function b() {
  at_top 'mix firmware.burn'
}

#--------------------------------------------------
# Build the firmware image
#--------------------------------------------------
function i() {
  at_top 'mix firmware.image'
}

#--------------------------------------------------
# Build the firmware patch
# TODO: Not currently working
#--------------------------------------------------
function p() {
  at_top 'mix firmware.patch'
}

#--------------------------------------------------
# Run Dev Tests
#--------------------------------------------------
function dt() {
  at_top 'MIX_ENV=test mix test'
}

#--------------------------------------------------
# Build the code
#--------------------------------------------------
function m() {
  at_top 'mix compile'
}

#--------------------------------------------------
# Run Check
#--------------------------------------------------
function c() {
  at_top 'mix format && mix check'
}

#--------------------------------------------------
# Run Clean
#--------------------------------------------------
function cl() {
  at_top 'mix clean'
}

export MIX_TARGET=bbb
