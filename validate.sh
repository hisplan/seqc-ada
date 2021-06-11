#!/usr/bin/env bash

java -jar ~/Applications/womtool.jar \
    validate \
    SEQC.wdl \
    --inputs ./configs/SEQC.inputs.json
