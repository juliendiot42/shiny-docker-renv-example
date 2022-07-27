# Example of `R Shiny` application with `renv` and Docker

This repository contains a very basic [`R-Shiny`](https://shiny.rstudio.com/) application that use the [`renv`](https://rstudio.github.io/renv/index.html) package for its dependencies and that can be run in a [Docker](https://www.docker.com/) container.

# Build the Docker image

First clone this repository and move inside.

```sh
git clone https://github.com/juliendiot42/shiny-docker-renv-example.git
cd shiny-docker-renv-example
```

You can now create a new image names `docker_renv_shiny_app` with the command:

```sh
docker build -t docker_renv_shiny_app .
```

# Start the application

You can now start the container with:

```sh
docker run --rm -p 3838:3838 docker_renv_shiny_app
```

> Note:
> - It is importat to map one of the host port to the container's port `3838` (which serve the shiny app). 
> - After the flag `-p` the first number is the host port and the second the container port.

## Access the app

You can then access the app by going to http://localhost:3838.
