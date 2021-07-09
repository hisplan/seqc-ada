version 1.0

import "modules/DoubletDetection.wdl" as module

workflow DoubletDetection {

    input {
        String sampleName
        File countMatrixH5ad
        Float voterThreshold

        # docker-related
        String dockerRegistry
    }

    call module.DoubletDetection {
        input:
            sampleName = sampleName,
            countMatrixH5ad = countMatrixH5ad,
            voterThreshold = voterThreshold,
            dockerRegistry = dockerRegistry
    }

    output {
        File doublets = DoubletDetection.doublets
        File doubletScore = DoubletDetection.doubletScore
        File notebook = DoubletDetection.notebook
    }
}
