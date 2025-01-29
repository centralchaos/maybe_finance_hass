#
## Stage 1: Use a full-featured image to create the database before switching
#FROM debian:bullseye as builder
#
## Install PostgreSQL client tools
#RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*
#
## Set working directory
#WORKDIR /app
#
## Copy the initialization script
#COPY init_db.sh /usr/local/bin/init_db.sh
#
## Make the script executable
#RUN chmod +x /usr/local/bin/init_db.sh
#
## Run the script to initialize the database
#RUN /bin/bash -c "/usr/local/bin/init_db.sh"

# Allow debugging in the console


ARG BUILD_ARCH
FROM --platform=${BUILD_ARCH} ghcr.io/maybe-finance/maybe:0.3.0
#RUN set -x
#
#COPY entrypoint.sh entrypoint.sh
#
#ENTRYPOINT ["sh", "/entrypoint.sh"]
#
#
#ENTRYPOINT ["/rails/bin/docker-entrypoint"]
#
## Start the server by default, this can be overwritten at runtime
#EXPOSE 3000
#CMD ["./bin/rails", "server"]
