#! /bin/bash
. .env
ps aux | awk -v timestamp="$(date +%s)" -v eventType="demoPsAux" '
BEGIN { ORS = ""; print " [ "}
NR>1 { printf "%s{\"user\": \"%s\", \"pid\": %s, \"cpu\": %s, \"mem\": %s, \"cmd\": \"%s\", \"eventType\": \"%s\", \"timestamp\": %s }",
      separator, $1, $2, $3, $4, $11, eventType, timestamp
  separator = ", "
}
END { print " ] " }' > demoPsAux.json
echo `gzip -c demoPsAux.json | curl -X POST -H "Content-Type: application/json" -H "X-Insert-Key: ${NEW_RELIC_INSIGHTS_KEY}" -H "Content-Encoding: gzip" https://insights-collector.newrelic.com/v1/accounts/${NEW_RELIC_ACCOUNT_ID}/events --data-binary @-`
echo
