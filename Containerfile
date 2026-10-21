FROM docker.io/library/eclipse-temurin:8-jdk AS unpack
COPY target/*.war /tmp/ROOT.war
ARG COMMIT_SHA="unknown"
ARG COMMIT_MSG=""
RUN mkdir -p /tmp/ROOT && \
    cd /tmp/ROOT && \
    jar xf /tmp/ROOT.war && \
    printf '{"sha":"%s","message":"%s","date":"%s"}' \
      "${COMMIT_SHA}" "${COMMIT_MSG}" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      > /tmp/ROOT/revision.json

FROM docker.io/library/tomcat:9-jre8
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=unpack /tmp/ROOT /usr/local/tomcat/webapps/ROOT
RUN chmod -R g+rw /usr/local/tomcat/webapps/ROOT
