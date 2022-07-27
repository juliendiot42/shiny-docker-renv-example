FROM rocker/shiny-verse
LABEL maintainer="Julien Diot <juliendiot42@gmail.com>"

# install system dependencies
RUN apt-get update && apt-get install -y \
  curl 

# create a new directory for the app code
RUN mkdir /myShinyApp

# use unpriviledged user "shinyAppUser" instead of "root"
RUN addgroup --system shinyAppUser \
    && adduser --system --ingroup shinyAppUser shinyAppUser
RUN usermod -a -G staff shinyAppUser # add user to staff group to install Rpkgs
RUN chown shinyAppUser:shinyAppUser /myShinyApp # give him access to app dir
USER shinyAppUser

# create and move to the directory containing the shinyAppUser
WORKDIR /myShinyApp

# install `renv`
ENV RENV_VERSION 0.15.5
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"


# install packages dependencies with `renv`
# copy renv information:
COPY --chown=shinyAppUser:shinyAppUser renv renv
COPY --chown=shinyAppUser:shinyAppUser renv.lock renv.lock
COPY --chown=shinyAppUser:shinyAppUser .Rprofile .Rprofile
# install deps:
RUN R -e 'renv::restore()'

# get app code from the host
COPY --chown=shinyAppUser:shinyAppUser . .

# run app on container at startup
EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/myShinyApp', host = '0.0.0.0', port = 3838)"]
