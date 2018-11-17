# Minimal Data Science Project Template

This repository contains a template for configuring a minimal data science evironment using docker.

When run it creates a debain based container, using a Miniconda install process from the [Anaconda Contiuum](https://www.anaconda.com/) distribution of Python.

It creates and runs a Jupyter Lab server under a non-priveleged user-defined account (defaults as `jupyter-user`). Packages and versions to install are easily through the `init/requirements.txt` file.

## Install instructions

1. Ensure you have [Docker installed](https://www.docker.com/products/docker-desktop) and running.
2. Clone this repository: `git clone https://github.com/RichardPBerry/datascience_template.git <your_project_name>`
3. Modify the contents of `init/requirements.txt` to specify the packages you need installed. Anaconda's package manager will take care of dependencies.
4. (Optional) - Modify the contents of `docker-compose.yml`. Things you may want to change:
    - `NB_USER`: The name of the account undeer which to run the notebook. Default is `jupyter`
    - `NB_PORT`: The port to run the notebook on within the container
    - `volumes:` Here is where you can define any persistent volumes for accessing data and scripts within the container, and after the container is stopped or deleted.

## Running the container
- `docker-compose up` - Builds the container if necessary (will take a while the first time), and runs the container. This will start a jupyter lab server, with the IP address and port specified through the output. Access the server through a web-broswer - note that you will need the token key to access. This is in the console output, and if you loose it you can also find it in the log file for the container under the `logvolume` directory.
- `docker-compose down` - Stops the container and removes it.
- `docker-compose build` - Run this to rebuild the container image. Only needed if you are tweaking files used during the build process, e.g. `init/start-notebook.sh`

## Folder structure
This project contains a suggested standardised folder structure that can be used as a base structure for a data science project. This folder structure has been compiled from a couple of different GitHub template repositories, that I can no longer remember. If that is you, many thanks!

Key folders are listed below. Note that with the exception of the init folder, all of these are **mounted under `/volume_data`** by docker compose when the container is run. Data that is created through a container in these directories will persist after the container is stopped or destroyed. Note that data saved in other locations **will not persist** once the container is destroyed.

- **data**: For storing project data. Add additional README files to subfolder as necessary to document file contents, folder structures and naming conventions etc.
- **init**: Files used during build or running of a docker image are stored here. These files are *copied* (not referenced) into the container during build.
- **logvolume**: Used to provide permanent storage for log files created by running containers. Log files are typically prefixed by the container name.
- **notebooks**: You should use the master notebook in the top level of the notebooks directory as the landing page for the project. If supplementary analysis notebooks are needed, also save them here.
- **reference**: Keep your reference material here, for example, literature articles, pdfs, powerpoint slides, or anything else that provides background or context.
- **src**: This folder should include function libraries, data munging scripts, or other code that would otherwise clutter the notebook. All high-level commands necessary to follow the analyses should be kept in the notebook.
- **test**: This folder should be used for unit tests for libraries and functions.