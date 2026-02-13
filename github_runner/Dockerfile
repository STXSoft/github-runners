FROM ubuntu:24.04 AS builder

ARG RUNNER_VERSION=2.331.0
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
    curl tar ca-certificates git

RUN mkdir /app && cd /app \
    && curl -o runner.tar.gz \
        -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf runner.tar.gz \
    && rm runner.tar.gz

FROM ubuntu:24.04
ENV RUNNER_HOME=/actions-runner
COPY --from=builder /app $RUNNER_HOME
RUN useradd -m -s /bin/bash runner \
    && chown -R runner:runner $RUNNER_HOME
WORKDIR $RUNNER_HOME
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    bash ca-certificates openssh-client curl git jq
RUN ./bin/installdependencies.sh
COPY --chown=runner:runner entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
USER runner
ENTRYPOINT ["/entrypoint.sh"]
