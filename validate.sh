#!/usr/bin/env bash

java -jar ~/Applications/womtool.jar \
    validate \
    SeqcAda.wdl \
    --inputs ./configs/tiny-chr9-10x-v2.inputs.json
