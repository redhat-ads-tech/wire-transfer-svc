#!/bin/sh
# Start Tomcat in the background, wait for WAR to unpack, inject revision.json
catalina.sh start

# Wait for ROOT to be unpacked (up to 30s)
for i in $(seq 1 30); do
  [ -d /usr/local/tomcat/webapps/ROOT/WEB-INF ] && break
  sleep 1
done

# Write revision info
printf '{"sha":"%s","message":"%s","date":"%s"}' \
  "${REVISION_SHA:-unknown}" \
  "${REVISION_MSG:-unknown}" \
  "${REVISION_DATE}" \
  > /usr/local/tomcat/webapps/ROOT/revision.json 2>/dev/null || true

# Follow Tomcat logs (keeps container alive)
tail -f /usr/local/tomcat/logs/catalina.out
