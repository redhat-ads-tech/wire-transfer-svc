FROM docker.io/library/tomcat:9-jre8
RUN rm -rf /usr/local/tomcat/webapps/*
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war
ARG COMMIT_SHA="unknown"
ARG COMMIT_MSG="local build"
ARG BUILD_DATE="unknown"
ENV REVISION_SHA="${COMMIT_SHA}" \
    REVISION_MSG="${COMMIT_MSG}" \
    REVISION_DATE="${BUILD_DATE}"
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
