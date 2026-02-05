ARG ARGOCD_VERSION=v3.3.0
FROM quay.io/argoproj/argocd:$ARGOCD_VERSION

USER root

RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV SOPS_VERSION=3.8.1
ENV HELM_SECRETS_VERSION=4.6.0

RUN curl -L https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64 -o /usr/local/bin/sops && \
    chmod +x /usr/local/bin/sops

USER argocd
RUN helm plugin install https://github.com/jkroepke/helm-secrets --version ${HELM_SECRETS_VERSION}

USER root
RUN echo '#!/bin/bash' > /usr/local/bin/helm-wrapper && \
    echo 'exec helm secrets "$@"' >> /usr/local/bin/helm-wrapper && \
    chmod +x /usr/local/bin/helm-wrapper

USER argocd