FROM mcr.microsoft.com/azure-cli:2.26.1

ENV BICEP_VERSION=0.4.412
LABEL version=${BICEP_VERSION}

RUN curl -Lo bicep https://github.com/Azure/bicep/releases/download/v${BICEP_VERSION}/bicep-linux-musl-x64 \
    && chmod +x ./bicep \
    && mv ./bicep /usr/local/bin/bicep

WORKDIR /bicep

ENTRYPOINT [ "bicep" ]
