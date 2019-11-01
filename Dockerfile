FROM ubuntu AS builder

ARG PYTHON_VERSIONS
RUN set -x \
        && build_deps='ca-certificates curl git libjpeg-dev build-essential make zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev libssl1.0-dev' \
        && apt-get update \
        && apt-get install --no-install-recommends -y $build_deps \
        && curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
ENV PATH /root/.pyenv/shims:/root/.pyenv/bin:$PATH
RUN set -x \
        && echo $PYTHON_VERSIONS | xargs -n 1 pyenv install \
        && pyenv global $PYTHON_VERSIONS
RUN apt-get purge -y --auto-remove $build_deps \
        && rm -rf /var/lib/apt/lists/*

from ubuntu
ENV PATH /root/.pyenv/shims:/root/.pyenv/bin:$PATH
COPY --from=builder /root/.pyenv /root/.pyenv
CMD bash
