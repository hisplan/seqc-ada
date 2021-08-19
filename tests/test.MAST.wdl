version 1.0

import "modules/MAST.wdl" as module

workflow MAST {

    input {
        File h5ad
        String clusterObsName = "Clusters"

        # docker-related
        String dockerRegistry
    }

    call module.MAST {
        input:
            h5ad = h5ad,
            clusterObsName = clusterObsName,
            dockerRegistry = dockerRegistry            
    }

    output {
        Array[File] out = MAST.out
    }
}
