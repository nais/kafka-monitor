FROM gradle:jdk8 as builder

RUN git clone --branch 2.0.0 https://github.com/linkedin/kafka-monitor.git
WORKDIR /home/gradle/kafka-monitor
RUN gradle build

FROM openjdk:8-jre-slim
EXPOSE 8000 8778

ENV KAFKA_HEAP_OPTS "-Xmx1024M"

ENV CREATE_TOPIC false
ENV MONITOR_TOPIC kafka-monitor
ENV REPLICATION_FACTOR 1
ENV PARTITIONS_TO_BROKERS_RATIO 2.0
ENV PRODUCE_DELAY 100
ENV ZOOKEEPER_CONNECT zookeeper1:1234,zookeeper2:1234,zookeeper3:1234
ENV BOOTSTRAP_SERVERS broker1:1234,broker2:1234,broker3:1234
ENV SECURITY_PROTOCOL SASL_SSL
ENV SASL_MECHANISM PLAIN
ENV JAAS_CONFIG ""
ENV VAULT_SECRETS_PATH /var/run/secrets/nais.io/vault
ENV JOLOKIA_URL ""

COPY --from=builder /home/gradle/kafka-monitor/bin/kafka-monitor-start.sh /kafka-monitor/bin/kafka-monitor-start.sh
COPY --from=builder /home/gradle/kafka-monitor/bin/kmf-run-class.sh /kafka-monitor/bin/kmf-run-class.sh
COPY --from=builder /home/gradle/kafka-monitor/config/log4j.properties /kafka-monitor/config/log4j.properties
COPY --from=builder /home/gradle/kafka-monitor/build /kafka-monitor/build
COPY --from=builder /home/gradle/kafka-monitor/webapp /kafka-monitor/webapp

COPY kafka-monitor.properties.in /kafka-monitor/config
COPY start.sh /kafka-monitor/bin

WORKDIR /kafka-monitor
CMD /kafka-monitor/bin/start.sh
