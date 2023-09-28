

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