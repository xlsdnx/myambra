# NOTE: This file should be converted into python and then removed

#!/usr/bin/env bash

source /envoy/test-helpers.sh

wait_and_curl http://lagotto /status "Lagotto status"
wait_and_curl http://lagotto /works "Lagotto works"
