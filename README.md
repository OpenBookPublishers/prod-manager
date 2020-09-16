# Prod Manager
Manage and execute OBP book production software via _makefile_.

# Requisites
You need [docker](https://packages.debian.org/buster/docker.io) and [git](https://packages.debian.org/buster/git) installed on your system.

# How it works
The _makefile_ serves two main purposes:
1. Clone git repository of OBP book production software and build the docker images of this software;
2. Run the docker containers.

# Installation
$ `make install`

This command initialises the input and output folders where to place input files and retrieve output files. After this, git repos are cloned and docker images are created.

# Run
`prod-manager` is able to handle two types of workflows:

 1. A generic workflow (suitable for most of OBP projects);
 2. A _PDF flow_ (designed for the projects which come out only as print and PDF editions).
 
## Run the generic workflow

Place the digital editions files in the input directory, named as: _file.epub_, _file.pdf_, _file.xml_, _file.json_. Then, run by typing:

$ `make`

Output files are stored in the `./output/` folder.

## Run PDF flow
Place the digital editions files in the input directory, named as: _file.pdf_ and _file.json_. Then, run by typing:

$ `make pdf-flow`

# Advanced use
Actions in the _makefile_ are purposely made very granular to allow the user some advanced tasks. Actions are named with this logic:
 -  a prefix named after one of the three main purposes of the software, namely `clone-`, `build-` and `run-`;
 -  the name of the software to run, such as `epublius`.

Examples are:
 -  $ `make clone-epublius`
 -  $ `make build-epublius`
 -  $ `make run-epublius`

# Clean
`$ make clean`
