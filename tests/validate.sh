#!/usr/bin/env bash

#hack: get dependency set up
ln -s ../modules/ modules

modules="MAST FastQC Utilities CellBender DoubletDetection scCB2 ToAnnData BasicAnalysis SEQC"

for module_name in $modules
do

    echo "Validating ${module_name}..."

    java -jar ~/Applications/womtool.jar \
        validate \
        test.${module_name}.wdl \
        --inputs test.${module_name}.inputs.json


done

#hack: remove symblock link to dependency
unlink modules
