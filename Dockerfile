# Use an official Ruby runtime as a parent image
FROM ruby:3.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set an environment variable to ensure that logs are sent straight to the terminal.
ENV RAILS_LOG_TO_STDOUT=true

# Set working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the Docker image
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install

# Copy the rest of the application code into the Docker image
COPY . .

# Precompile assets (if applicable)
RUN bundle exec rake assets:precompile

# Expose port 3000 to the Docker host
EXPOSE 3000

# Start the Rails server
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0 -p 3000"]
