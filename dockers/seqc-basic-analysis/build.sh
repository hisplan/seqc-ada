#!/bin/bash

source version.sh

docker build . --tag seqc-basic-analysis:${version}
