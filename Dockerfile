FROM quay.io/argoproj/argocd:latest

USER root

RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG SOPS_VERSION=v3.9.0
RUN curl -L https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64 -o /usr/local/bin/sops && \
    chmod +x /usr/local/bin/sops

ARG AGE_VERSION=v1.1.0
RUN curl -L https://github.com/FiloSottile/age/releases/download/${AGE_VERSION}/age-${AGE_VERSION}-linux-amd64.tar.gz | tar xz && \
    mv age/age /usr/local/bin/age && \
    mv age/age-keygen /usr/local/bin/age-keygen && \
    rm -rf age

RUN mkdir -p /home/argocd/cmp-server/config

USER argocd