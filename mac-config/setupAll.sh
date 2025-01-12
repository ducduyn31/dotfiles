#!/bin/bash

set -e

# This script will install all the necessary packages for the project
for package in $(ls -d */); do
  # Check if setup.sh exists in the package
  if [ -f $package/setup.sh ]; then
    echo "Setting up $package using custom script"
    cd $package
    ./setup.sh
    cd ..
  else
    # Setup using stow
    echo "Setting up $package using stow"
    stow -t ~ $package
  fi
done

echo "All packages have been setup successfully"

