
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kafka In Sync Replica Alert for Under-Replicated Topics
---

This incident type refers to an alert triggered by the Kafka system when one or more topics have under-replicated data due to an insufficient number of in-sync replicas. In-sync replicas are replicas that are fully caught up with the leader replica and are considered reliable for serving data to consumers. When the number of in-sync replicas drops below a certain threshold, the Kafka system raises an alert to notify administrators to investigate and take corrective action to ensure data consistency and availability.

### Parameters
```shell
export TOPIC_NAME="PLACEHOLDER"

export ZOOKEEPER_URL="PLACEHOLDER"

export KAFKA_LOG_FILE="PLACEHOLDER"

export NEW_PARTITION_COUNT="PLACEHOLDER"

export KAFKA_HOME_DIRECTORY="PLACEHOLDER"

export NEW_REPLICATION_FACTOR="PLACEHOLDER"

export BROKER_HOST_PORT="PLACEHOLDER"
```

## Debug

### 1. Check the status of the Kafka brokers
```shell
systemctl status kafka
```

### 2. Verify that all Kafka brokers are up and running
```shell
kafka-topics.sh --describe --zookeeper ${ZOOKEEPER_URL} --topic ${TOPIC_NAME}
```

### 3. Check the in-sync replicas for each partition of the under-replicated topic
```shell
kafka-topics.sh --describe --zookeeper ${ZOOKEEPER_URL} --topic ${TOPIC_NAME} --under-replicated-partitions
```

### 4. Check the replication factor for the under-replicated topic
```shell
kafka-topics.sh --describe --zookeeper ${ZOOKEEPER_URL} --topic ${TOPIC_NAME} | grep ReplicationFactor
```

### 5. Check the ISR (in-sync replica) count for each partition of the under-replicated topic
```shell
kafka-topics.sh --describe --zookeeper ${ZOOKEEPER_URL} --topic ${TOPIC_NAME} | grep Isr
```

### 6. Check the logs for any errors or warnings related to the under-replicated topic
```shell
tail -f ${KAFKA_LOG_FILE}
```

### 7. Check the network connectivity between the Kafka brokers and Zookeeper
```shell
ping ${ZOOKEEPER_URL}
```

### The replication factor for the affected topics may have been set too low, increasing the likelihood of under-replication.
```shell


#!/bin/bash



# Set the broker host and port

broker=${BROKER_HOST_PORT}



# Set the topic name

topic=${TOPIC_NAME}



# Get the replication factor for the topic

replication_factor=$(kafka-topics --bootstrap-server $broker --describe --topic $topic | awk '/ReplicationFactor/ {print $3}')



# Compare the replication factor with a threshold value

threshold=2

if [ $replication_factor -lt $threshold ]; then

    echo "Replication factor for topic $topic is too low: $replication_factor (threshold is $threshold)"

    # Perform additional diagnostic checks or actions here

else

    echo "Replication factor for topic $topic is sufficient: $replication_factor"

fi


```

## Repair

### Increase the replication factor for the affected topic to ensure that there are more replicas of the partitions available.
```shell


#!/bin/bash



# Set the variables

KAFKA_HOME=${KAFKA_HOME_DIRECTORY}

TOPIC=${TOPIC_NAME}

REPLICATION_FACTOR=${NEW_REPLICATION_FACTOR}



# Increase the replication factor for the topic

$KAFKA_HOME/bin/kafka-topics.sh --zookeeper localhost:2181 --alter --topic $TOPIC --partitions ${NEW_PARTITION_COUNT} --replication-factor $REPLICATION_FACTOR



# Check if the replication factor has been updated

$KAFKA_HOME/bin/kafka-topics.sh --zookeeper localhost:2181 --describe --topic $TOPIC


```