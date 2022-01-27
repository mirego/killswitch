#!/bin/sh
set -e

echo "Executing migrations…"
bundle exec rake db:migrate

echo "Executing the main web process…"
exec "$@"
