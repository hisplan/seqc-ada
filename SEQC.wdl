version 1.0

import "modules/RunSEQC.wdl" as RunSEQC

workflow SEQC {

    input {
        String version
        String assay

        # this should be all string
        # because SEQC handles downloading files
        # no localization required
        String index
        String barcodeFiles
        String genomicFastq
        String barcodeFastq

        String starArguments
        String outputPrefix
        String email
    }

    call RunSEQC.RunSEQC {
        input:
            version = version,
            assay = assay,
            index = index,
            barcodeFiles = barcodeFiles,
            genomicFastq = genomicFastq,
            barcodeFastq = barcodeFastq,
            starArguments = starArguments,
            outputPrefix = outputPrefix,
            email = email
    }
}
