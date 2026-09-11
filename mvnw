#!/bin/sh
set -e
script_dir="$(cd "$(dirname "$0")" && pwd)"
exec java -Dmaven.multiModuleProjectDirectory="$script_dir" \
  -classpath "$script_dir/.mvn/wrapper/maven-wrapper.jar" \
  org.apache.maven.wrapper.MavenWrapperMain "$@"
