#!/bin/bash
echo "Cleaning, packaging and deploying to Exchange"
mvn clean deploy -DskipTests
echo "Deploying to CloudHub2..."
mvn mule:deploy \
    -DmuleDeploy \
    -Danypoint.platform.username=YOUR_ANYPOINT_USERNAME \
    -Danypoint.platform.password=YOUR_ANYPOINT_PASSWORD \
    -Dmule.env=YOUR_ENVIRONMENT \
    -Dmule.key=YOUR_ENCRYPTION_KEY \
    -Dag.client_id=YOUR_ENVIRONMENT_CLIENT_ID \
    -Dag.client_secret=YOUR_ENVIRONMENT_CLIENT_SECRET
echo "Done."
