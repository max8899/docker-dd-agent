FROM alpine:3.3

ENV DD_HOME /opt/datadog-agent

# Add Docker check
COPY conf.d/docker_daemon.yaml /etc/dd-agent/conf.d/docker_daemon.yaml

# Expose supervisor port
EXPOSE 9001/tcp

# Expose DogStatsD port
EXPOSE 8125/udp

COPY setup_agent.sh /setup_agent.sh
COPY entrypoint.sh /entrypoint.sh

# Install minimal dependencies
RUN apk add --update curl python tar

# Install the agent
RUN sh -c "$(cat /setup_agent.sh)"

RUN cp "$DD_HOME/agent/datadog.conf.example" "$DD_HOME/agent/datadog.conf"

ENTRYPOINT ["/entrypoint.sh"]

CMD cd "$DD_HOME" && source venv/bin/activate && supervisord -c agent/supervisor.conf
