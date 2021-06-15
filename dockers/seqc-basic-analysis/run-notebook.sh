#!/bin/bash

source version.sh

docker run -it --rm \
    -p 8888:8888 \
    -v $(pwd)/notebooks:/home/jovyan/work \
    seqc-basic-analysis:${version}
