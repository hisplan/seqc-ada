version 1.0

import "modules/BasicAnalysis.wdl" as module

workflow BasicAnalysis {

    input {
        String sampleName
        File pathRawAdata
        File pathFilteredAdata

        Int numCpus
        Int memoryGB

        # docker-related
        String dockerRegistry
    }

    call module.BasicAnalysis {
        input:
            sampleName = sampleName,
            pathRawAdata = pathRawAdata,
            pathFilteredAdata = pathFilteredAdata,
            numCpus = numCpus,
            memoryGB = memoryGB,
            dockerRegistry = dockerRegistry
    }

    output {
        File notebook = BasicAnalysis.notebook
        File normalizedH5ad = BasicAnalysis.normalizedH5ad
        File notebookStdout = BasicAnalysis.notebookStdout
    }
}
