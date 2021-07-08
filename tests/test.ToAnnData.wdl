version 1.0

import "modules/ToAnnData.wdl" as module

workflow ToAnnData {

    input {
        String sampleName
        File denseMatrix
        File sparseBarcodes
        File sparseGenes
        File sparseMoleculeCounts
        File sparseReadCounts

        # docker-related
        String dockerRegistry
    }

    call module.ToAnnData {
        input:
            sampleName = sampleName,
            denseMatrix = denseMatrix,
            sparseBarcodes = sparseBarcodes,
            sparseGenes = sparseGenes,
            sparseMoleculeCounts = sparseMoleculeCounts,
            sparseReadCounts = sparseReadCounts,
            dockerRegistry = dockerRegistry
    }

    output {
        File filteredH5ad = ToAnnData.filteredH5ad
        File rawH5ad = ToAnnData.rawH5ad
    }
}
