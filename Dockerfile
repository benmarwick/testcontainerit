FROM rocker/verse:3.6.0
LABEL maintainer="bmarwick"
# CRAN packages skipped because they are in the base image:
RUN ["install2.r", "compendium", "here"]
WORKDIR compendium/
