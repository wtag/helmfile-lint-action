FROM dtzar/helm-kubectl:3.6.3

ENV HELM_HOME=/root/.helm
ENV HELMFILE_VERSION=v0.140.0
ENV SOPS_VERSION=v3.7.1

RUN apk add --update-cache gnupg sed

# helmfile
RUN wget https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 -O /usr/local/bin/helmfile && chmod 755 /usr/local/bin/helmfile

# SOPS
RUN curl -sL https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux --output /usr/local/bin/sops && chmod 755 /usr/local/bin/sops

COPY entrypoint.sh /entrypoint.sh
COPY sops_functional_tests_key.asc /sops_functional_tests_key.asc

ENTRYPOINT ["/entrypoint.sh"]
