ARG DEXELS_BASE_COMMIT=unknown
ARG DEXELS_BASE_REMOTE=unknown

FROM openjdk:17

RUN apt-get update && apt-get install -y vim less net-tools git telnet && \
    mkdir /home/navajouser /log /output /storage /temp && \
    groupadd -r navajouser -g 433 && \
    useradd -u 431 -r -g navajouser -d /home/navajouser -s /sbin/nologin -c "Docker image user" navajouser && \
    chown -R navajouser:navajouser /home/navajouser /log /output /storage /temp
COPY --chown=431:433 unpack/felix /opt/felix 
COPY --chown=431:433 scripts/startup.sh /opt/felix/startup.sh
RUN chmod a+x /opt/felix/*.sh

EXPOSE 8181
ENV GIT_REPOSITORY_TEMP="/temp"
ENV GIT_REPOSITORY_OUTPUT="/output"
ENV GIT_REPOSITORY_STORAGE="/storage"
ENV CONSOLE_USER="dexels"
ENV CONSOLE_PASS="{sha-256}eHpwVX+AFnneRThtRif+1CReQTxIkxHnQebptWE8aW4="
ENV FELIX_OPTS="-Dorg.eclipse.jetty.server.Request.maxFormContentSize=3000000 -Djava.net.preferIPv4Stack=true "

USER navajouser
ENTRYPOINT ["/opt/felix/startup.sh"]
