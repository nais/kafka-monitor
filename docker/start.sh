#!/bin/sh

if test -r $VAULT_SECRETS_PATH/jaasConfig; then
    JAAS_CONFIG=$(cat $VAULT_SECRETS_PATH/jaasConfig)
fi

if test ! -z "$JAAS_CONFIG"; then
    export JAAS_CONFIG="$(echo $JAAS_CONFIG | sed 's/"/\\"/g')"
fi

if test ! -z "$JOLOKIA_URL"; then
   perl -pi -e 's/(.*new Jolokia\(\{url:\s*\").*?(\"\}.*)/\1$ENV{JOLOKIA_URL}\2/;' /kafka-monitor/webapp/index.html
fi

perl -p -e 's/\$\{(\w+)\}/$ENV{$1}/eg; s/.*:\s*\"\"\s*,?.*//;' < /kafka-monitor/config/log4j.properties.in > /kafka-monitor/config/log4j.properties
perl -p -e 's/\$\{(\w+)\}/$ENV{$1}/eg; s/.*:\s*\"\"\s*,?.*//;' < /kafka-monitor/config/kafka-monitor.properties.in > /kafka-monitor/config/kafka-monitor.properties
/kafka-monitor/bin/kafka-monitor-start.sh /kafka-monitor/config/kafka-monitor.properties

