# BasicNabEnvSetup
Basic conda environment set up for Nab with deltarice and nabPy. This repo includes a setup.sh script you can use to create a conda environment with both deltarice and nabPy installed. Instructions for running the script described. Instructions for installing nabPy and deltarice manually are also described. Additional features for Nab analysis work, like connecting to remote server with VS Code, are also described. Instructions for installing conda are described at the end. 

# With conda Installed
If you have conda installed, you can git clone this repo and run the setup.sh file, which uses the .yml file provided here, to install and setup a conda environment with deltarice and nabPy. This will create a conda environment, install dependencies, and install deltarice and nabPy. You can then activate this environment and use nabPy. This is the quickest way to get an environment set up with deltarice and nabPy. You can also install everything on you own, which is also described below. 

## Run Environment setup.sh Script
Clone repo
```
git clone https://github.com/arlee-shelby/BasicNabEnvSetup.git
```
Go into repo directory
```
cd BasicNabEnvSetup
```
Run setup script
```
./setup.sh
```
This will create a conda environment named "NabEnv" using the BasicNabEnv.yml file included in this repo. The environment will be in /path/to/your/conda/envs/NabEnv. This is also where deltarice and nabPy are clones and installed. The script also adds the path to deltarice and nabPy into the environment variables, so you do not have to do this manually. You should be able to import deltarice and nabPy anywhere, with your conda environment activated. 

To activate and deactivate the environment
```
conda activate NabEnv
```
```
conda deactivate NabEnv
```
If you would like to change the name of the environment, you can use the -n flag when running the script
```
./setup.sh -n yourenvironmentname
```
If you have a different .yml file you would like to use to set up the environment, you can use the -y flag when running the script
```
./setup.sh -y yourenvironmentymlfile.yml
```

## Set up conda Environment Manually: with deltarice and nabPy
Create conda environment and activate
```
conda create --name yourenvironmentname
```
Make sure you are have/use python version>3.3 for deltarice install to work. You can specify the python version when you create your conda environment
```
conda create --name yourenvironmentname python=3.3
```
```
conda activate yourenvironmentname
```
### 1. Install Dependencies for deltarice and nabPy
* Install conda-build to add paths to deltarice and nabPy as environment variables
```
conda install conda-build
```
* Install dependencies for deltarice
This shows installation for hdf5 version 1.12.2 and h5py with openmpi support
```
conda install -c conda-forge hdf5=1.12.2=mpi_openmpi_*
```
```
conda install -c conda-forge h5py=*=mpi_*
```
* Install dependencies for nabPy
```
conda install matplotlib
```
```
conda install dask
```
```
conda install scipy
```
```
conda install numba
```
Note: if any of the installations fail, you can try specifying the channel and priority before conda install, and try again
```
conda config --add channels conda-forge
```
```
conda config --set channel_priority strict
```
### 2. Install deltarice
I recommend you install deltarice in your environment directory. This allows you to keep track of the deltarice location (in case you have many builds) and keep it associated with your environment.
Go to where you would like to install deltarice
```
cd path/to/your/conda/environment
```
Clone deltarice
```
git clone https://gitlab.com/dgma224/deltarice.git
```
Go into deltarice directory
```
cd deltarice
```
Install
```
python setup.py install
```
Add deltarice path to your environment: To add path, you need to add the parent directory of the package you want to add, in this case it is the conda environment where you cloned deltarice
```
conda-develop /path/to/your/conda/environment
```
Check install worked
```
python
```
```
> import deltarice
```
### 3. Install nabPy
Again, I recommend you install nabPy in your environment directory.
Go to where you would like to install nabPy
```
cd path/to/your/conda/environment
```
Clone nabPy
```
git clone https://gitlab.com/NabExperiment/pyNab.git
```
Add nabPy path to your environment: To add path, you need to add the parent directory of the package you want to add, in this case nabPy is in the parent pyNab/src directory
```
conda-develop /path/to/your/conda/environment/pyNab/src
```
Check install worked
```
python
```
```
> import nabPy
```
## Create Your own .yml File from conda Environment
If you would like to create your own .yml file to auto-setup a conda environment with the packages you have installed, you export it from your activated environment with the --from-history flag. This will create a .yml file that can be run on any operating system. Note, deltarice and nabPy will not be included in a .yml file because they are not found on the common conda channels. You will have to manually install them yourself every time, or use the setup.sh script (or something like it) described above, and in this repo. 
```
conda env export --from-history > yourenvironmentymlfile.yml
```
## Create conda Environment from .yml File
You can create a conda environment from your own .yml file. If you install additional packages to the basic ones needed for nabPy and deltarice, you can export a .yml file as described above, and create a conda environment from that with any packages you want installed. 
```
conda env create -f yourenvironmentymlfile.yml -n yourenvironmentname
```

# Additional Features
* If you have VS Code installed on your personal laptop, you can connect to the remote server through ssh. You need to install openssh. I recommend you install this in your conda environment. With your environment activated:
```
conda install openssh
```
* You can also connect to your conda environment's python by installing ipykernel in your conda environment. With your environment activated:
```
conda install ipykernel
```
Now you can connect to the remote server and use deltarice, nabPy, and any other packages you have installed, on your local computer VS Code application. You may need to install other VS Code extensions on your local computer to have everything fully work. 

# Installing conda
You can refer to https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html about conda install instructions for you OS system. These instructions will be for installing miniconda3 on a Linux.
You can find miniconda3 downloads combatible with your python version here https://repo.anaconda.com/miniconda/
Get miniconda3 download: This is for python version 3.9
```
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_25.1.1-2-Linux-x86_64.sh
```
Install
```
bash Miniconda3-py39_25.1.1-2-Linux-x86_64.sh
```
You will be prompted with 
```
Do you wish to update your shell profile to automatically initialize conda?
This will activate conda on startup and change the command prompt when activated.
If you'd prefer that conda's base environment not be activated on startup,
   run the following command when conda is activated:
   
conda config --set auto_activate_base false

You can undo this by running conda init --reverse $SHELL? [yes|no]
```
Type "yes". This will initilize conda and auto-activate the base conda environment. Generally, you want to have conda initiallized, but you don't want the base environment to be activated automatically. 
To not auto-activate the base environment
```
conda config --set auto_activate_base false
```
To check conda installation: should output conda usage and option information
```
conda
```
