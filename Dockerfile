FROM dtzar/helm-kubectl:2.17.0

ENV HELM_HOME=/root/.helm
ENV HELMFILE_VERSION=v0.116.0

# helm
RUN helm init --client-only

# helmfile
RUN wget https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 -O /usr/local/bin/helmfile && chmod 755 /usr/local/bin/helmfile

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
