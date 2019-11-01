# Python Multiversion base image

This builds a Docker image with the following python versions available:

- 3.8.0
- 3.7.5
- 3.6.9
- 3.5.7
- 3.4.10
- 2.7.17

They are available with the following names inside the container:

- python3.8
- python3.7
- python3.6
- python3.5
- python3.4
- python2.7

The image is based on Ubuntu (latest).

The purpose is to test software against multiple versions of Python using a
tool such as tox (https://github.com/tox-dev/tox).

## Building



## Usage

Make a test script to run inside this environment, for example:

```sh
#!/usr/bin/env bash

# set up
pip install --no-cache tox

# run
tox
```

Run a container from this image, mounting your source code and test script,
and run:

```sh
docker run --rm \
   -v $(shell pwd):/code \
   -w /code \
   python-multiversion:1.0.1 \
   ./test.sh
```
