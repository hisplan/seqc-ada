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

    output {
        File alignedBam = RunSEQC.alignedBam
        File mergedFastq = RunSEQC.mergedFastq

        File denseMatrix = RunSEQC.denseMatrix

        File sparseBarcodes = RunSEQC.sparseBarcodes
        File sparseGenes = RunSEQC.sparseGenes
        File sparseMoleculeCounts = RunSEQC.sparseMoleculeCounts
        File sparseReadCounts = RunSEQC.sparseReadCounts

        File h5 = RunSEQC.h5

        File miniSummary = RunSEQC.miniSummary
        File alignmentSummary = RunSEQC.alignmentSummary
        File summary = RunSEQC.summary

        File deGeneList = RunSEQC.deGeneList

        File preCorrectionReadArray = RunSEQC.preCorrectionReadArray
        File cbCorrection = RunSEQC.cbCorrection
        File? umiCorrection = RunSEQC.umiCorrection

        File daskReport = RunSEQC.daskReport
        File? log = RunSEQC.log
    }
}
