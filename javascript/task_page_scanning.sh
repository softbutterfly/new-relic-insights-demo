#! /bin/bash
. .env
node ./index.js
echo `gzip -c pageScanning.json | curl -X POST -H "Content-Type: application/json" -H "X-Insert-Key: ${NEW_RELIC_INSIGHTS_KEY}" -H "Content-Encoding: gzip" https://insights-collector.newrelic.com/v1/accounts/${NEW_RELIC_ACCOUNT_ID}/events --data-binary @-`
echo
