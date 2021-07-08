version 1.0

import "modules/scCB2.wdl" as module

workflow scCB2 {

    input {
        String sampleName
        File sparseBarcodes
        File sparseGenes
        File sparseMoleculeCounts

        # docker-related
        String dockerRegistry
    }

    call module.scCB2 {
        input:
            sampleName = sampleName,
            sparseBarcodes = sparseBarcodes,
            sparseGenes = sparseGenes,
            sparseMoleculeCounts = sparseMoleculeCounts,
            dockerRegistry = dockerRegistry
    }

    output {
        File realCells = scCB2.realCells
    }
}
