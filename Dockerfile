# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.4.2
FROM docker.io/library/ruby:$RUBY_VERSION

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl build-essential git libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy gem files first to leverage Docker layer caching
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Expose the port Rails runs on
EXPOSE 3000

# Set environment to development
ENV RAILS_ENV=development \
    BUNDLE_WITHOUT=""

# Entry point script
ENTRYPOINT ["./bin/docker-entrypoint"]

# Start the server
CMD ["rails", "server", "-b", "0.0.0.0"]
