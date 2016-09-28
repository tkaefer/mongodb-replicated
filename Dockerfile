FROM mongo:latest

RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

MAINTAINER Tobias Kaefer <tobias@tkaefer.de>

# MongoDB image inspired by https://github.com/sclorg/mongodb-container
# using the default mongodb docker image
#
# Volumes:
#  * /data/db - Datastore for MongoDB
# Environment:
#  * $MONGODB_USER - Database user name
#  * $MONGODB_PASSWORD - User's password
#  * $MONGODB_DATABASE - Name of the database to create
#  * $MONGODB_ADMIN_PASSWORD - Password of the MongoDB Admin

ENV MONGODB_VERSION=3.2 \
    HOME=/data \
    CONTAINER_SCRIPTS_PATH=/usr/local/share/container-scripts/mongodb \
    ENABLED_COLLECTIONS=mongodb

LABEL io.k8s.description="MongoDB is a scalable, high-performance, open source NoSQL database." \
      io.k8s.display-name="MongoDB 3.2" \
      io.openshift.expose-services="27017:mongodb" \
      io.openshift.tags="database,mongodb"

RUN set -x \
    && apt-get update \
	  && apt-get install -y gettext-base \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 27017

ADD root/usr/local /usr/local

RUN touch /etc/mongod.conf && chown mongodb:0 /etc/mongod.conf && /usr/local/libexec/fix-permissions /etc/mongod.conf

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mongod"]
