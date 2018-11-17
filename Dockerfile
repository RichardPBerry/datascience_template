# Use an official Python runtime as a parent image
FROM debian:latest
ARG NB_USER=jupyter
ARG NB_PORT=8888

#Expose a range of ports to listen on for Jupyter notebook
EXPOSE 8888-8900

# Update and get useful tools
RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the timezone
ENV TZ=Australia/Sydney
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# Create a non-priveleged user to run the container and notebook
# Copy the contents of the init folder into this area
ENV NB_USER=${NB_USER} \
    NB_UID=1000
RUN adduser -uid ${NB_UID} --disabled-password --gecos "" --shell /bin/bash ${NB_USER}
COPY ./init /home/${NB_USER}/init
WORKDIR /home/${NB_USER}


# Create a permanent storage area for volume mounts
# Make sure $NB_USER has read/write permissions
RUN mkdir /volume_data && \
    chown -R ${NB_USER}:${NB_USER} /volume_data


# Perform actions as new user
USER ${NB_UID}

# Install miniconda
# Note 'source' is not a synonym for '.' when using the system shell: /bin/sh 
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O /home/${NB_USER}/miniconda.sh && \
    /bin/bash /home/${NB_USER}/miniconda.sh -b -p /home/${NB_USER}/conda && \
    rm ~/miniconda.sh && \ 
    echo ". /home/${NB_USER}/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc


# Install any needed packages specified in requirements.txt
RUN . /home/${NB_USER}/conda/etc/profile.d/conda.sh && \
    conda clean -tipsy && \
    conda install -y --file /home/${NB_USER}/init/requirements.txt


# Swith to root user and start a cron job when the container starts to keep it active
USER root
#CMD /bin/bash /home/${NB_USER}/init/cron.sh
CMD su ${NB_USER} -c "/bin/bash /home/${NB_USER}/init/start-notebook.sh ${NB_PORT}"


# To build
# docker build -t <image name> --build-arg NB_USER=foomonster .

# To run
# docker run -p 8888-8900:8888-8900 <image name>
# docker run -it -p 8888-8900:8888-8900 <image name> //bin/bash