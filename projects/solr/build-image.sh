#!/usr/bin/env bash

$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../build-helpers.sh \
  build_java_image plos-solr solr

# source $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../build-helpers.sh
# build_java_image plos-solr solr
