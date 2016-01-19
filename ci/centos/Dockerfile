FROM qserv/stack:centos_latest
MAINTAINER Fabrice Jammes <fabrice.jammes@in2p3.fr>

USER root
RUN yum install -y git

# MariaDB dependencies
RUN yum install -y cmake zlib-devel xz-devel ncurses-devel
# TODO is libxml2 useful?

# Needed by git build
RUN yum install -y gettext perl-devel
# For debugging purpose
RUN yum install -y vim

USER qserv
RUN bash -c ". /qserv/stack/loadLSST.bash && eups distrib install git 1.8.5.2"
RUN mkdir -p /home/qserv/src/mariadb
COPY eups-build.sh /home/qserv/
CMD ["bash", "/home/qserv/eups-build.sh"]
