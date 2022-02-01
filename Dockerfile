FROM ruby:2.7.5-alpine3.13

# Install runtime dependencies
RUN apk update && apk upgrade && apk add --no-cache bash build-base git nodejs npm tzdata postgresql-dev

# Copy all required files
WORKDIR /opt/killswitch
ADD . /opt/killswitch/
RUN mkdir -p /opt/killswitch/tmp

# Install Ruby dependencies
RUN bundle install --binstubs --without development test

# Create user
RUN adduser -D killswitch
RUN chown -R killswitch: /opt/killswitch
USER killswitch

# Install JavaScript dependencies
RUN npm install

# Pre-compile assets
RUN SECRET_KEY_BASE=__UNUSED_BUT_REQUIRED__ RAILS_ENV=production bundle exec rake assets:precompile

# Copy entrypoint script
COPY scripts/docker-entrypoint.sh /usr/local/bin
USER root
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

# Execute entrypoint script
ENTRYPOINT ["docker-entrypoint.sh"]
CMD bundle exec puma -p $PORT -C config/puma.rb
