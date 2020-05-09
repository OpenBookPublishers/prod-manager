# Prod Manager
Manage and execute OBP book production software via _makefile_.

# Requisites
You need [docker](https://packages.debian.org/buster/docker.io) and [git](https://packages.debian.org/buster/git) installed on your system.

# How it works
The _makefile_ serves three purposes:
1. Clone git repository of OBP book production software;
2. Build the docker images of the software;
3. Run the docker containers.

Operations can be invoked selectively (i.e. `make run-epublius`), but there are handy shortcuts to speed things up:

`$ make clone-all`

`$ make build-all`

`$ make run-all`

# Setup
$ `make setup` initialises the input and output folders where to place input files and retrieve output files.

# Run
Place the digital editions files in the input directory, named as: _file.epub_, _file.pdf_, _file.xml_, _file.json_ and then run the `make` command you need.

# Clean
`$ make clean`
