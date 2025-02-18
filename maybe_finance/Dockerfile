# Stage 1: Clone the Maybe Finance repository
ARG BUILD_ARCH
FROM --platform=${BUILD_ARCH} alpine/git AS clone
WORKDIR /src
RUN apk add --no-cache git && \
    git clone https://github.com/maybe-finance/maybe.git . && \
    git checkout e9b29f67268e326a8ed3ec53d07351187cc31fd7

# -------------------------------------------------
# Stage 2: Base image with necessary dependencies
FROM --platform=${BUILD_ARCH} ruby:3.4.1-slim AS base

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libvips postgresql-client jq bash build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

WORKDIR /rails


# Instead of copying from the build context, copy Gemfile and Gemfile.lock from the clone stage
COPY --from=clone /src/Gemfile /rails/Gemfile
COPY --from=clone /src/Gemfile.lock /rails/Gemfile.lock

# Install gems
RUN bundle install
RUN rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git
RUN bundle exec bootsnap precompile --gemfile -j 0


# -------------------------------------------------
# Stage 3: Build stage
FROM base AS build

WORKDIR /rails
COPY --from=clone /src /rails

# Install build dependencies
#RUN apt-get update -qq && \
#    apt-get install --no-install-recommends -y \
#    curl libvips postgresql-client jq bash build-essential git libpq-dev pkg-config && \
#    rm -rf /var/lib/apt/lists/*

# Precompile bootsnap and assets
#RUN bundle exec bootsnap precompile -j 0 app/ lib/
RUN bundle exec bootsnap precompile -j 0 app/ lib/
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# -------------------------------------------------
# Final stage
FROM base

# Clean up installation packages to reduce image size
RUN rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /rails /rails

# Copy startup script
COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

# Entrypoint prepares the database.
ENTRYPOINT ["/usr/local/bin/run.sh"]

CMD ["./bin/rails", "server"]