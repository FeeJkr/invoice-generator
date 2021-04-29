#!/bin/bash
set -e

exec /usr/bin/supervisord --nodaemon -c /app/docker/supervisord.conf
