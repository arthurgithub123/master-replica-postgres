#!/bin/bash

# exit immediately if a command exits with a non-zero status
set -e

# Execute in background (&) so Postgres initialization
# does not block here (try removing & and see what happens).
# If it is not in background replica initialization blocks
# and will never start its TCP Sockets and the subscription
# can not be done (because it will be done through TCP Socket).
../subscription.sh &
