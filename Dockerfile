# Use official Ruby image
FROM ruby:3.1.1

# Install dependencies needed for Rails in development
# (node for asset processing, psql client for convenience)
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    nodejs postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfiles first to leverage Docker layer caching
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.4.14 && bundle install

# Copy the rest of the app
COPY . ./

# Expose port 3000
EXPOSE 3000

# Start the Rails server in development
CMD ["bash", "-lc", "bundle exec rails server -b 0.0.0.0 -p 3000"]
