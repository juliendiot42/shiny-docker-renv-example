FROM rocker/shiny-verse
LABEL maintainer="Julien Diot <juliendiot42@gmail.com>"

# install system dependencies
RUN apt-get update && apt-get install -y \
  curl 

# install `renv`
ENV RENV_VERSION 0.15.5
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

# create and move to the directory containing the shinyAppUser
WORKDIR /myShinyApp

# install packages dependencies with `renv`
# copy renv information:
COPY renv renv
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
# install deps:
RUN R -e 'renv::restore()'
# isolate renv from the cache (own by `root`):
RUN R -e 'renv::isolate()'

# get app code from the host
COPY . .

# use unpriviledged user "shinyAppUser" instead of "root"
RUN addgroup --system shinyAppUser \
    && adduser --system --ingroup shinyAppUser shinyAppUser
RUN chown shinyAppUser:shinyAppUser -R .
USER shinyAppUser

# run app on container at startup
EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/myShinyApp', host = '0.0.0.0', port = 3838)"]
