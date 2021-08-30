FROM gitpod/workspace-full

USER root

RUN apt update && apt install -y curl xz-utils g++ git

USER gitpod

SHELL ["/bin/bash", "-c"]

# nim
RUN curl https://nim-lang.org/choosenim/init.sh -sSf | bash -s -- -y
ENV PATH=/home/gitpod/.nimble/bin:$PATH
