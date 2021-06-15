version 1.0

import "modules/BasicAnalysis.wdl" as module

workflow BasicAnalysis {

    input {
        String path
    }

    call module.BasicAnalysis

    output {
        File outNotebook = BasicAnalysis.outNotebook
    }
}
