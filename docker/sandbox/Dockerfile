# Ruby Sandbox Container for LearnRuby
# Isolated environment for executing user code safely

FROM ruby:3.4-alpine

# Install only necessary packages
RUN apk add --no-cache \
    build-base \
    && rm -rf /var/cache/apk/*

# Create non-root user for security
RUN addgroup -g 1000 sandbox && \
    adduser -u 1000 -G sandbox -s /bin/sh -D sandbox

# Install RSpec
RUN gem install rspec --no-document

# Set up working directory
WORKDIR /sandbox

# Set restrictive permissions
RUN chown -R sandbox:sandbox /sandbox

# Switch to non-root user
USER sandbox

# Default command
CMD ["ruby", "--version"]
