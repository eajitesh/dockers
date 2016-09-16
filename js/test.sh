# Build the image test
docker build -t ctest -f test.df .

# Start the container
docker run -ti -dP --name $1 -v /c/Users/$2/dockers:/mnt/src ctest:latest /bin/bash
