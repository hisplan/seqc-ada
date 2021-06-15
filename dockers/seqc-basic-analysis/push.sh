#!/bin/bash

source version.sh

docker login
docker tag seqc-basic-analysis:${version} hisplan/seqc-basic-analysis:${version}
docker push hisplan/seqc-basic-analysis:${version}
