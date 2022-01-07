FROM python:alpine
ARG TARGETARCH

LABEL maintainer="TRW <trw@acoby.de>" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="ansible-ci" \
      org.label-schema.description="A simple container wrapper around some command line tool" \
      org.label-schema.url="https://github.com/acoby/ansible-ci" \
      org.label-schema.vendor="acoby GmbH"

ENV PYTHONUNBUFFERED 1
ENV PYTHONIOENCODING UTF-8

RUN apk add --no-cache --update git yamllint curl openssh openssh-keygen && \
    apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev openssl-dev && \
    adduser -u 5000 -h /home/worker -D worker && \
    /usr/local/bin/python3 -m pip install --upgrade pip && \
    /usr/local/bin/python3 -m pip install netaddr passlib requests pywinrm && \
    /usr/local/bin/python3 -m pip install ansible && \
    /usr/local/bin/python3 -m pip install ansible-lint && \
    /usr/local/bin/python3 -m pip install ansible-tower-cli && \
    /usr/local/bin/python3 -m pip install awxkit && \
    apk del .build-deps gcc musl-dev libffi-dev openssl-dev

WORKDIR /home/worker
USER worker
RUN ssh-keygen -t rsa -b 4096 -q -C "CICD User" -f /home/worker/.ssh/id_rsa -N ""

CMD ["/usr/local/bin/ansible-lint", "--help"]
