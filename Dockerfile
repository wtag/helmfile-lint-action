FROM dtzar/helm-kubectl:3.18.6

ENV HELM_HOME=/root/.helm
ENV HELMFILE_VERSION=1.1.6
ENV SOPS_VERSION=v3.7.3

RUN apk add --update-cache gnupg sed

# helmfile
RUN curl -sL https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz \
    -o helmfile.tar.gz && \
    tar -xzf helmfile.tar.gz && \
    mv helmfile /usr/local/bin/helmfile && \
    chmod 755 /usr/local/bin/helmfile && \
    rm helmfile.tar.gz

# SOPS
RUN curl -sL https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux --output /usr/local/bin/sops && chmod 755 /usr/local/bin/sops

COPY entrypoint.sh /entrypoint.sh
COPY sops_functional_tests_key.asc /sops_functional_tests_key.asc

ENTRYPOINT ["/entrypoint.sh"]
