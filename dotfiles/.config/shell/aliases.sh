#
# Docker container aliases
#

# Need to add launching these containers.
alias ub="docker run -v ~/.aws:/root/.aws -it your-image"
alias al2="docker run -v ~/.aws:/root/.aws -it your-image"

# Build Docker images
alias ub-build="docker build -t dev-env-ubuntu -f docker/ubuntu/Dockerfile ."
docker al2-build="build -t dev-env-amazon -f docker/amazon-linux/Dockerfile ."
