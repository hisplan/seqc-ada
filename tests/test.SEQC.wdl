version 1.0

import "modules/SEQC.wdl" as module

workflow SEQC {

    input {
        String version
        String assay

        # this should be all string
        # because SEQC handles downloading files
        # no localization required
        String index
        String barcodeFiles
        Array[File] fastqGenomic
        Array[File] fastqBarcode

        String filterMode
        Int? maxInsertSize
        String? extraParameters

        String starArguments
        String outputPrefix
        String email

        # docker-related
        String dockerRegistry
    }

    call module.SEQC {
        input:
            version = version,
            assay = assay,
            index = index,
            barcodeFiles = barcodeFiles,
            fastqGenomic = fastqGenomic,
            fastqBarcode = fastqBarcode,
            filterMode = filterMode,
            maxInsertSize = maxInsertSize,
            extraParameters = extraParameters,
            starArguments = starArguments,
            outputPrefix = outputPrefix,
            email = email,
            dockerRegistry = dockerRegistry
    }

    output {
        File alignedBam = SEQC.alignedBam
        File mergedFastq = SEQC.mergedFastq

        File denseMatrix = SEQC.denseMatrix

        File sparseBarcodes = SEQC.sparseBarcodes
        File sparseGenes = SEQC.sparseGenes
        File sparseMoleculeCounts = SEQC.sparseMoleculeCounts
        File sparseReadCounts = SEQC.sparseReadCounts

        Array[File] rawFeatureBCMatrix = SEQC.rawFeatureBCMatrix

        File h5 = SEQC.h5

        File miniSummaryPdf = SEQC.miniSummaryPdf
        File miniSummaryJson = SEQC.miniSummaryJson
        File alignmentSummary = SEQC.alignmentSummary
        File summary = SEQC.summary

        Array[File] mast = SEQC.mast
        File deGeneList = SEQC.deGeneList

        File preCorrectionReadArray = SEQC.preCorrectionReadArray
        File cbCorrection = SEQC.cbCorrection
        File umiCorrection = SEQC.umiCorrection

        File daskReport = SEQC.daskReport
        File? log = SEQC.log
    }
}
