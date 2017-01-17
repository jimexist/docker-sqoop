#!/bin/bash
. /etc/bootstrap.sh

set -euf -o pipefail

echo "starting sqoop2 server"
sqoop2-server start

exec tail -f $SQOOP_HOME/@LOGDIR@/sqoop.log
