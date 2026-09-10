#!/bin/sh
set -e
script_dir="$(cd "$(dirname "$0")" && pwd)"
exec java -jar "$script_dir/.mvn/wrapper/maven-wrapper.jar" "$@"
