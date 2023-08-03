
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High incoming connections on MongoDB
---

This incident type typically involves a high volume of incoming connections to a MongoDB database, which can cause performance issues and potentially impact the availability of the database. It often requires investigation and remediation to prevent further issues.

### Parameters
```shell
# Environment Variables

export HOST="PLACEHOLDER"

export PORT="PLACEHOLDER"

export PATH_TO_MONGODB_LOG="PLACEHOLDER"

export MAX_CONNECTIONS="PLACEHOLDER"

```

## Debug

### Check MongoDB connection status
```shell
mongo ${HOST}:${PORT} --eval "db.runCommand({ping:1})"
```

### Check MongoDB connection limit
```shell
mongo ${HOST}:${PORT} --eval "db.runCommand({whatsmyuri:1}).limit"
```

### Check available MongoDB connections
```shell
mongo ${HOST}:${PORT} --eval "db.serverStatus().connections"
```

### Check MongoDB replication status
```shell
mongo ${HOST}:${PORT} --eval "rs.status()"
```

### Check current MongoDB read/write operations
```shell
mongo ${HOST}:${PORT} --eval "db.currentOp()"
```

### Check MongoDB system logs for any errors
```shell
tail -f /var/log/mongodb/mongod.log
```

### Check MongoDB configuration file for connection limits and timeouts
```shell
cat /etc/mongod.conf
```

## Repair

### Set the path to the MongoDB log file
```shell
LOG_FILE=${PATH_TO_MONGODB_LOG}
```

### Check if the log file exists
```shell
if [ ! -f "$LOG_FILE" ]; then

    echo "MongoDB log file not found."

    exit 1

fi
```

### Search the log file for entries related to incoming connections
```shell
grep "incoming connection" "$LOG_FILE"
```

### If no entries are found, exit with an error message
```shell
if [ $? -ne 0 ]; then

    echo "No incoming connection entries found in MongoDB log file."

    exit 1

fi
```

### If entries are found, print them to the console
```shell
echo "Incoming connection entries found in MongoDB log file:"

grep "incoming connection" "$LOG_FILE"
```

### Increase the maximum number of allowed connections to accommodate the current traffic or add additional resources to handle the incoming connections.
```shell


#!/bin/bash

# Set the maximum number of connections to ${MAX_CONNECTIONS}

max_connections=${MAX_CONNECTIONS}

# Edit the MongoDB configuration file to set the maximum number of connections

sudo sed -i "s/^maxIncomingConnections.*/maxIncomingConnections: $max_connections/" /etc/mongod.conf

# Restart the MongoDB service to apply the changes

sudo systemctl restart mongod

```