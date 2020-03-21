suppressPackageStartupMessages(library("containerit"))

# Ideally we run this function and get a Dockerfile that
# - copies all the files into the container
# - renders the Rmd during build
# - gives us RStudio server in the browswer when run for interactive work

df_description <- dockerfile(from = here::here("DESCRIPTION"),
                             image = paste0('rocker/verse:',
                                            paste0(R.version$major,".",R.version$minor)),
                             container_workdir = 'compendium/',
                             filter_baseimage_pkgs = TRUE,
                             copy = "script_dir" ) # not clear that this does anything

## Q How to stop my local pkg from being mistaken as a CRAN pkg?

# inspect the Dockerfile
print(df_description)

# write to a file:
containerit::write(df_description, file = 'Dockerfile')

## Q How to remove that final line: CMD ["R"]  ?

df_description <- readLines('Dockerfile')
df_description <- df_description[-length(df_description)]
writeLines(df_description, 'Dockerfile')

# build the Dockerfile object with stevedore:
containerit::docker_build('.')

# run container stand-alone, nothing is copied

## Q How to copy all compendium files into this container?

```{shell}
docker run -dp 8787:8787 -e ROOT=TRUE -e USER=rstudio -e PASSWORD=xyz f299
```

# I can see my files with the Docker volume attached to my project directory:

```{shell}
docker run -dp 8787:8787 -e ROOT=TRUE -e USER=rstudio -e PASSWORD=xyz  -v "$(pwd):/home/rstudio" f299
```

# when you are finished working, you can free up memory by stopping the container with this:

docker stop $(docker ps -a -q)

# check to see if any containers are running

docker ps

# when you are completely done and don't need the container again at all, you can free up hard drive space by deleting all images with this:

docker rmi -f $(docker images -q)

