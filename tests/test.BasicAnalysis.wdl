version 1.0

import "modules/BasicAnalysis.wdl" as module

workflow BasicAnalysis {

    input {
        String sampleName
        File pathRawAdata
        File pathFilteredAdata

        # docker-related
        String dockerRegistry
    }

    call module.BasicAnalysis {
        input:
            sampleName = sampleName,
            pathRawAdata = pathRawAdata,
            pathFilteredAdata = pathFilteredAdata,
            dockerRegistry = dockerRegistry
    }

    output {
        File notebook = BasicAnalysis.notebook
    }
}
