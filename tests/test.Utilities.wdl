version 1.0

import "modules/Utilities.wdl" as module

workflow Utilities {

    input {
        Array[File] fastqcZip
        File seqcMiniSummary
        File sparseBarcodes
        File sparseGenes
    }

    call module.GetNumOfReads {
        input:
            fastqcZip = fastqcZip[0]
    }

    call module.GetTotalReads {
        input:
            fastqcZip = fastqcZip
    }

    call module.GetNumOfCells {
        input:
            seqcMiniSummary = seqcMiniSummary
    }

    call module.CalcSeqcRequiredMemory {
        input:
            numOfReads = GetTotalReads.totalReads
    }

    call module.CalcRawCountMatrixMemory {
        input:
            sparseBarcodes = sparseBarcodes,
            sparseGenes = sparseGenes
    }

    output {
        Int numOfReads = GetNumOfReads.numOfReads
        Int totalReads = GetTotalReads.totalReads
        Int numOfCells = GetNumOfCells.numOfCells
        Int memorySeqcGB = CalcSeqcRequiredMemory.memoryGB
        Int memoryRawCountMatrix = CalcRawCountMatrixMemory.memoryGB
    }
}
