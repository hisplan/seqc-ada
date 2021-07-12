version 1.0

import "modules/FastQC.wdl" as FastQC
import "modules/SEQC.wdl" as SEQC
import "modules/ToAnnData.wdl" as ToAnnData
import "modules/scCB2.wdl" as scCB2
import "modules/DoubletDetection.wdl" as DoubletDetection
import "modules/BasicAnalysis.wdl" as BasicAnalysis
import "modules/Utilities.wdl" as Utilities

workflow SeqcAba {

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

    # run FastQC on barcode fastq
    scatter (fastqFile in fastqBarcode) {
        call FastQC.FastQC as FastQCBarcode {
            input:
                fastqFile = fastqFile,
                dockerRegistry = dockerRegistry
        }
    }

    # run FastQC on genomic fastq
    scatter (fastqFile in fastqGenomic) {
        call FastQC.FastQC as FastQCGenomic {
            input:
                fastqFile = fastqFile,
                dockerRegistry = dockerRegistry
        }
    }

    # use one of the fastq to get the number of reads
    call Utilities.GetNumOfReads {
        input:
            fastqcZip = FastQCGenomic.outZip[0]
    }

    # calculate memory required for SEQC based on num of reads
    call Utilities.CalcSeqcRequiredMemory {
        input:
            numOfReads = GetNumOfReads.numOfReads
    }

    call SEQC.SEQC {
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
            memoryGB = CalcSeqcRequiredMemory.memoryGB,
            email = email,
            dockerRegistry = dockerRegistry
    }

    # compute memory required for ToAnnData based on SEQC sparse count matrix
    call Utilities.CalcRawCountMatrixMemory {
        input:
            sparseBarcodes = SEQC.sparseBarcodes,
            sparseGenes = SEQC.sparseGenes
    }

    call ToAnnData.ToAnnData {
        input:
            sampleName = outputPrefix,
            denseMatrix = SEQC.denseMatrix,
            sparseBarcodes = SEQC.sparseBarcodes,
            sparseGenes = SEQC.sparseGenes,
            sparseMoleculeCounts = SEQC.sparseMoleculeCounts,
            sparseReadCounts = SEQC.sparseReadCounts,
            memoryGB = CalcRawCountMatrixMemory.memoryGB + 3,
            dockerRegistry = dockerRegistry
    }

    call scCB2.scCB2 {
        input:
            sampleName = outputPrefix,
            sparseBarcodes = SEQC.sparseBarcodes,
            sparseGenes = SEQC.sparseGenes,
            sparseMoleculeCounts = SEQC.sparseMoleculeCounts,
            dockerRegistry = dockerRegistry
    }

    call DoubletDetection.DoubletDetection {
        input:
            sampleName = outputPrefix,
            countMatrixH5ad = ToAnnData.filteredH5ad,
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

        # QC
        Array[File] fastqcBarcode = FastQCBarcode.outHtml
        Array[File] fastqcGenomic = FastQCGenomic.outHtml

        # SEQC
        File alignedBam = SEQC.alignedBam
        File mergedFastq = SEQC.mergedFastq

        File h5 = SEQC.h5

        File miniSummaryPdf = SEQC.miniSummaryPdf
        File miniSummaryJson = SEQC.miniSummaryJson
        File alignmentSummary = SEQC.alignmentSummary
        File summary = SEQC.summary

        Array[File] mast = SEQC.mast
        File deGeneList = SEQC.deGeneList

        File preCorrectionReadArray = SEQC.preCorrectionReadArray
        File cbCorrection = SEQC.cbCorrection
        File? umiCorrection = SEQC.umiCorrection

        File daskReport = SEQC.daskReport
        File? log = SEQC.log

        # scCB2, DoubletDetection
        File realCells = scCB2.realCells
        File doublets = DoubletDetection.doublets
        File doubletScore = DoubletDetection.doubletScore

        # notebook
        File rawH5ad = ToAnnData.rawH5ad
        File filteredH5ad = ToAnnData.filteredH5ad
        File notebook = BasicAnalysis.notebook
    }
}
