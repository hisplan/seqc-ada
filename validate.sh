#!/usr/bin/env bash

java -jar ~/Applications/womtool.jar \
    validate \
    SeqcAda.wdl \
    --inputs ./configs/template.inputs.json
