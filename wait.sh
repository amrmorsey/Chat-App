#!/bin/bash
set -e

host="$1"
shift
cmd="$@"

until curl -s "$host"; do
  >&2 echo "Elasticsearch is unavailable - sleeping"
  sleep 1
done

>&2 echo "Elasticsearch is up - executing command"
exec $cmd