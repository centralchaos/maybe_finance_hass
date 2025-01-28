FROM ghcr.io/maybe-finance/maybe:stable

# Switch to root for package installation
USER root

# Install PostgreSQL and sudo with proper cleanup
RUN apt-get update && \
    apt-get install -y postgresql postgresql-contrib sudo libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Configure sudo for rails user
RUN echo "rails ALL=(postgres) NOPASSWD:ALL" > /etc/sudoers.d/rails-postgres && \
    chmod 0440 /etc/sudoers.d/rails-postgres

# Copy our run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Switch back to application user
USER 1000:1000

# Use our script as entrypoint
ENTRYPOINT ["/run.sh"]