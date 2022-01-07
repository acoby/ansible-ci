FROM python:alpine
LABEL maintainer="TRW <trw@acoby.de>" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="ansible-ci" \
      org.label-schema.description="A simple container wrapper around some command line tool" \
      org.label-schema.url="https://github.com/acoby/ansible-ci" \
      org.label-schema.vendor="acoby GmbH"

RUN apk add --no-cache --update git yamllint curl && \
    apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev openssl-dev && \
    /usr/local/bin/python3 -m pip install --upgrade pip && \
    /usr/local/bin/python3 -m pip --no-cache install netaddr passlib requests pywinrm && \
    /usr/local/bin/python3 -m pip --no-cache install ansible-tower-cli && \
    /usr/local/bin/python3 -m pip --no-cache install ansible-lint && \
    /usr/local/bin/python3 -m pip --no-cache install ansible && \
    /usr/local/bin/python3 -m pip --no-cache install awxkit && \
    apk del .build-deps gcc musl-dev libffi-dev openssl-dev

CMD ["/usr/local/bin/ansible-lint", "--help"]
