

#!/bin/bash



# Set the variables

KAFKA_HOME=${KAFKA_HOME_DIRECTORY}

TOPIC=${TOPIC_NAME}

REPLICATION_FACTOR=${NEW_REPLICATION_FACTOR}



# Increase the replication factor for the topic

$KAFKA_HOME/bin/kafka-topics.sh --zookeeper localhost:2181 --alter --topic $TOPIC --partitions ${NEW_PARTITION_COUNT} --replication-factor $REPLICATION_FACTOR



# Check if the replication factor has been updated

$KAFKA_HOME/bin/kafka-topics.sh --zookeeper localhost:2181 --describe --topic $TOPIC