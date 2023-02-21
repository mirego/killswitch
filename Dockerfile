FROM ruby:3.2.1-alpine3.17 AS base

# Create and define work directory
WORKDIR /opt/killswitch

# Install OS dependencies
RUN apk --update --no-cache add nodejs tzdata libpq && \
  gem update --system 3.4.1 && gem update --system


FROM base AS build

# Copy only the minimal required files
COPY . /opt/killswitch/

# Update system and install dependencies
RUN apk --update --no-cache add --virtual build-dependencies build-base git nodejs npm postgresql-dev && \
  bundle config set --local without 'development test' && \
  bundle install && \
  bundle binstubs --all && \
  npm set progress=false && \
  npm install --silent --production && \
  SECRET_KEY_BASE=__UNUSED_BUT_REQUIRED__ RAILS_ENV=production bundle exec rake assets:precompile


FROM base AS release

COPY . .
COPY --from=build /usr/local/bundle/ /usr/local/bundle/
COPY --from=build /opt/killswitch/public/assets/ /opt/killswitch/public/assets/
COPY --from=build /opt/killswitch/node_modules/ /opt/killswitch/node_modules/

# Copy entrypoint script
COPY scripts/docker-entrypoint.sh /usr/local/bin
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

# Create user
RUN adduser -D -h /opt/killswitch -u 5000 killswitch && \
  chown -R killswitch: /opt/killswitch

USER killswitch

HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1

# Execute entrypoint script
ENTRYPOINT ["docker-entrypoint.sh"]
CMD bundle exec puma -p $PORT -C config/puma.rb
