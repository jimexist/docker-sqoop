#!/bin/bash
set -euf -o pipefail
. /etc/bootstrap.sh

echo "starting sqoop2 server"
sqoop2-server start

tail -f $SQOOP_HOME/@LOGDIR@/sqoop.log
