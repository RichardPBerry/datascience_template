# init

Files used during build or running of a docker image are stored here. These files are *copied* (not referenced) into the container during build. Updating files in this folder will not affect a running container until the container is rebuilt or restarted (depending on where the script is used)