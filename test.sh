#!/usr/bin/env bash

if [[ $# < 2 ]]; then
    echo "usage: test.sh image-name python-version [python-version ...]"
    exit
fi

imgname=$1
shift

while [[ $# > 0 ]]; do
    version=$1
    short_version=$(echo $version | cut -d. -f-2)
    echo "Checking for python${short_version}..."
    # python 2 prints the version to stderr...
    output=$(docker run --rm $imgname python${short_version} --version 2>&1)
    if [[ $? != 0 ]]; then
        echo "Fail: python${short_version} not found"
        exit 1
    fi
    if [[ $output != "Python ${version}" ]]; then
        echo "Fail: \"${output}\" doesn't look like Python ${version}"
        exit 2
    fi
    echo "Found ${output}"
    shift
done

echo "OK"
