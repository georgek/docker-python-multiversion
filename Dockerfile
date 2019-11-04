FROM ubuntu

ARG PYTHON_VERSIONS
ENV PATH /root/.pyenv/shims:/root/.pyenv/bin:$PATH

RUN set -x \
        && build_deps='curl git libjpeg-dev build-essential make' \
        && runtime_deps='ca-certificates zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev libssl1.0-dev' \
        && apt-get update \
        && apt-get install --no-install-recommends -y $build_deps $runtime_deps \
        && curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
        && echo $PYTHON_VERSIONS | xargs -n 1 pyenv install \
        && pyenv global $PYTHON_VERSIONS \
        && apt-get purge -y --auto-remove $build_deps \
        && rm -rf /var/lib/apt/lists/*

CMD bash
