FROM ghcr.io/maybe-finance/maybe:stable

# Install PostgreSQL dependencies
RUN apt-get update && apt-get install -y \
    postgresql \
    postgresql-contrib \
    && rm -rf /var/lib/apt/lists/*

# Copy our run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Preserve any existing entrypoint/cmd from base image
ENTRYPOINT ["/run.sh"]