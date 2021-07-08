version 1.0

import "modules/SEQC.wdl" as SEQC
import "modules/ToAnnData.wdl" as ToAnnData
import "modules/BasicAnalysis.wdl" as BasicAnalysis

workflow SeqcAba {

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

        String filterMode
        Int? maxInsertSize
        String? extraParameters

        String starArguments
        String outputPrefix
        String email

        # docker-related
        String dockerRegistry
    }

    call SEQC.SEQC {
        input:
            version = version,
            assay = assay,
            index = index,
            barcodeFiles = barcodeFiles,
            genomicFastq = genomicFastq,
            barcodeFastq = barcodeFastq,
            filterMode = filterMode,
            maxInsertSize = maxInsertSize,
            extraParameters = extraParameters,
            starArguments = starArguments,
            outputPrefix = outputPrefix,
            email = email,
            dockerRegistry = dockerRegistry
    }

    call ToAnnData.ToAnnData {
        input:
            sampleName = outputPrefix,
            denseMatrix = SEQC.denseMatrix,
            sparseBarcodes = SEQC.sparseBarcodes,
            sparseGenes = SEQC.sparseGenes,
            sparseMoleculeCounts = SEQC.sparseMoleculeCounts,
            sparseReadCounts = SEQC.sparseReadCounts,
            dockerRegistry = dockerRegistry
    }

    call BasicAnalysis.BasicAnalysis {
        input:
            sampleName = outputPrefix,
            pathRawAdata = ToAnnData.rawH5ad,
            pathFilteredAdata = ToAnnData.filteredH5ad,
            dockerRegistry = dockerRegistry
    }

    output {
        File alignedBam = SEQC.alignedBam
        File mergedFastq = SEQC.mergedFastq

        File h5 = SEQC.h5

        File miniSummaryPdf = SEQC.miniSummaryPdf
        File miniSummaryJson = SEQC.miniSummaryJson
        File alignmentSummary = SEQC.alignmentSummary
        File summary = SEQC.summary

        File deGeneList = SEQC.deGeneList

        File preCorrectionReadArray = SEQC.preCorrectionReadArray
        File cbCorrection = SEQC.cbCorrection
        File? umiCorrection = SEQC.umiCorrection

        File daskReport = SEQC.daskReport
        File? log = SEQC.log

        File rawH5ad = ToAnnData.rawH5ad
        File filteredH5ad = ToAnnData.filteredH5ad
        File notebook = BasicAnalysis.notebook
    }
}
