FROM ruby:2.7.6-alpine3.16

# Install runtime dependencies
RUN apk update && apk upgrade && apk add --no-cache bash build-base git nodejs npm tzdata postgresql-dev

# Copy all required files
WORKDIR /opt/killswitch
COPY . /opt/killswitch/
RUN mkdir -p /opt/killswitch/tmp

# Update Ruby-provided Bundler version (via rubygems update)
RUN gem update --system 3.0.8 && gem update --system

# Install Ruby dependencies
RUN bundle install --binstubs --without development test

# Copy entrypoint script
COPY scripts/docker-entrypoint.sh /usr/local/bin
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

# Create user
RUN adduser -D killswitch
RUN chown -R killswitch: /opt/killswitch
USER killswitch

# Install JavaScript dependencies
RUN npm install

# Pre-compile assets
RUN SECRET_KEY_BASE=__UNUSED_BUT_REQUIRED__ RAILS_ENV=production bundle exec rake assets:precompile

# Execute entrypoint script
ENTRYPOINT ["docker-entrypoint.sh"]
CMD bundle exec puma -p $PORT -C config/puma.rb
