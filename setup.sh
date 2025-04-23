#!/bin/bash

# Exit on error
set -e

# Check if conda is installed
if ! command -v conda &> /dev/null; then
    echo "Error: conda is not installed"
    exit 1
fi

# Make sure not in some activated conda enviorment
conda deactivate

# Help for options
Help()
{
   # Display Help
   echo "Create conda enviorment from .yml file for with deltarice and nabPy"
   echo
   echo "Syntax: scriptTemplate [-g|h|v|V]"
   echo "options:"
   echo "g     Print the GPL license notification."
   echo "h     Print this Help."
   echo "v     Verbose mode."
   echo "V     Print software version and exit."
   echo
}

# Set default enviorment name and .yml file name
EnviormentName="NabEnv"
EnviormentYAMLName="BasicNabEnv.yml"

# Get the input options
while getopts ":hny:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      n) # Enter a name for the enviorment
         EnviormentName=$OPTARG;;
      y) #enter name to enviorment .yml file
         EnviormentYAMLName=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

# If "EnviormentName" exists already, delete to start new
echo "Deleting old enviorment if found"
conda env remove -n "$EnviormentName" || true

# Check python version, need python>=3.3 for deltarice install
python_version="$(python3 --version)"
required_python="3.3.0"
 if [ "$(printf '%s\n' "$required_python" "$python_version" | sort -V | head -n1)" = "$required_python" ]; then 
        echo "Current python version: $python_version is greater than or equal to $required_python, can continue"
 else
        echo "Python3 version Less than required python: $required_python"
        exit 1
 fi

# Create conda enviorment from .yml file if it exists
echo "Creating enviorment from .yml file"
if [ ! -f "$EnviormentYAMLName" ]; then
   echo "Error: .yml file does not exist, cannot create enviorment"
   exit 1
fi
conda env create -f "$EnviormentYAMLName" -n "$EnviormentName" python=3

# Activate environment
echo "activating enviorment"
source $(conda info --base)/etc/profile.d/conda.sh
conda activate "$EnviormentName"

echo "$(python --version)"

# Clone DeltaRice repo in enviorment directory
echo "Cloning deltarice"
cd "$CONDA_PREFIX"
git clone https://github.com/david-mathews-1994/deltarice.git

# Go into deltarice directory and install
echo "Installing deltarice"
cd deltarice
python setup.py install

# Add path to deltarice as an enviorment variable, deltarice installed in enviorment directory
echo "Add deltarice path"
conda-develop "$CONDA_PREFIX"

# Test deltarice installation
echo "Test deltarice install"
python -c "import deltarice; print('deltarice installation successful')"

#Go back to enviorment directory
cd ..

# Clone nabPy repo in enviorment directory
echo "Cloning nabPy"
git clone https://gitlab.com/NabExperiment/pyNab.git

# Add path to nabPy as an enviorment variable, nabPy installed in "enviorment directory"/pyNab/src
echo "Add nabPy path"
conda-develop "$CONDA_PREFIX"/pyNab/src

# Test nabPy installation
echo "Test nabPy install"
python -c "import nabPy; print('nabPy installation successful')"

echo "Created conda enviroment: name= $EnviormentName with deltarice and nabPy and was successful!"

