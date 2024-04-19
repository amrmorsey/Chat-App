# Use the official Ruby image
FROM ruby:3.0.2

# Set environment variables
ENV RAILS_ROOT /var/www/chat_app
ENV RAILS_ENV development

# Set working directory
WORKDIR $RAILS_ROOT

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y nodejs yarn

# Install bundler
RUN gem install bundler

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy application code
COPY . .

# Start Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
