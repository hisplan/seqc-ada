version 1.0

import "modules/CellBender.wdl" as module

workflow CellBender {

    input {
        String sampleName
        File features
        File barcodes
        File matrix
        Boolean cuda
        Int expectedCells
        Float fpr = 0.01
        Int epochs = 150
    }

    call module.CellBender {
        input:
            sampleName = sampleName,
            features = features,
            barcodes = barcodes,
            matrix = matrix,
            cuda = cuda,
            expectedCells = expectedCells,
            fpr = fpr,
            epochs = epochs
    }

    output {
        File outH5 = CellBender.outH5
        File outFilteredH5 = CellBender.outFilteredH5
        File outCellBarcodes = CellBender.outCellBarcodes
        File outPdf = CellBender.outPdf
        File outLog = CellBender.outLog
    }
}
