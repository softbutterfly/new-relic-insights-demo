#! /bin/bash
. .env
ps aux | awk -v timestamp="$(date +%s)" -v eventType="demoDf" '
BEGIN { ORS = ""; print " [ "}
NR>1 { printf "%s{\"filesystem\": \"%s\", \"size\": %s, \"used\": %s, \"avail\": %s, \"mountedOn\": \"%s\", \"eventType\": \"%s\", \"timestamp\": %s }",
      separator, $1, $2, $3, $4, $5, eventType, timestamp
  separator = ", "
}
END { print " ] " }' > demoDf.json
echo `gzip -c demoDf.json | curl -X POST -H "Content-Type: application/json" -H "X-Insert-Key: ${NEW_RELIC_INSIGHTS_KEY}" -H "Content-Encoding: gzip" https://insights-collector.newrelic.com/v1/accounts/${NEW_RELIC_ACCOUNT_ID}/events --data-binary @-`
echo
