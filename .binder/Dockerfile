FROM rocker/binder:3.6.0
LABEL maintainer='Eirini Zormpa'
USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}
USER ${NB_USER}



RUN wget https://github.com/eirini-zormpa/KPLS5/raw/master/DESCRIPTION && R -e "options(repos = list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/2020-03-10/')); devtools::install_deps()"

RUN rm DESCRIPTION.1; exit 0
