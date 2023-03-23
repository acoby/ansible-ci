# ansible-ci

A simple container to run some CI/CD processes. 

We use them to test our Ansible roles.

We install

- ansible
- ansible-lint
- yamllint
- molecule[docker]

and several python libraries, like

- jmespath
- netaddr
- passlib
- requests
- pywinrm
- bcrypt

to use this image out-of-the-box for several CI/CD processes like linting and molecule tests.

Here is an example Gitlab config:

```
---
stages:
  - lint
  - test

ansible-lint:
  stage: lint
  image: "docker.io/acoby/ansible-ci:latest"
  script:
    - "echo 'Running ansible-lint tests'"
    - "ansible-lint *"

yaml-lint:
  stage: lint
  image: "docker.io/acoby/ansible-ci:latest"
  script:
    - "echo 'Running yamllint'"
    - "yamllint -f colored ."

molecule:
  stage: test
  image: "docker.io/acoby/ansible-ci:latest"
  services:
    - name: "docker:dind"
      command: ["--mtu=1420"]
  variables:
    DOCKER_HOST: tcp://docker:2375/
    DOCKER_DRIVER: overlay2
    DOCKER_TLS_CERTDIR: ""
    DOCKER_OPTS: "--mtu 1420"
  script:
    - molecule test
```