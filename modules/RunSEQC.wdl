version 1.0

task RunSEQC {

    input {
        String version
        String assay
        String index
        String barcodeFiles
        String genomicFastq
        String barcodeFastq
        String starArguments
        String outputPrefix
        String email

        Float inputSize = 250
        Int numCores = 8
        Int memoryGB = 100
    }

    String dockerImage = "hisplan/cromwell-seqc:" + version

    command <<<
        set -euo pipefail

        # `--local` still requires AWS region to be speicifed
        export AWS_DEFAULT_REGION=us-east-1

        # run locally and do not terminate
        SEQC run ~{assay} \
            --index ~{index} \
            --barcode-files ~{barcodeFiles} \
            --genomic-fastq ~{genomicFastq} \
            --barcode-fastq ~{barcodeFastq} \
            --star-args ~{starArguments} \
            --output-prefix ~{outputPrefix} \
            --email ~{email} \
            --local --no-terminate

            # no-filter-low-coverage: ""
            # min-poly-t: "0"

            # filter-mode: snRNA-seq
            # max-insert-size: 2304700

        # hack: optional output doesn't seem to be supported
        if [ ! -r "~{outputPrefix}_umi-correction.csv.gz" ]
        then
            touch "~{outputPrefix}_umi-correction.csv.gz"
        fi

        ls -al
    >>>

    output {
        File alignedBam = outputPrefix + "_Aligned.out.bam"
        File mergedFastq = outputPrefix + "_merged.fastq.gz"

        File denseMatrix = outputPrefix + "_dense.csv"

        File sparseBarcodes = outputPrefix + "_sparse_counts_barcodes.csv"
        File sparseGenes = outputPrefix + "_sparse_counts_genes.csv"
        File sparseMoleculeCounts = outputPrefix + "_sparse_molecule_counts.mtx"
        File sparseReadCounts = outputPrefix + "_sparse_read_counts.mtx"

        File h5 = outputPrefix + ".h5"

        File miniSummary = outputPrefix + "_mini_summary.pdf"
        File alignmentSummary = outputPrefix + "_alignment_summary.txt"
        File summary = outputPrefix + "_summary.tar.gz"

        # Array[File] mast = glob(outputPrefix + "_cluster_*_mast_input.csv")
        File deGeneList = outputPrefix + "_de_gene_list.txt"

        File preCorrectionReadArray = "pre-correction-ra.pickle"
        File cbCorrection = outputPrefix + "_cb-correction.csv.gz"
        File? umiCorrection = outputPrefix + "_umi-correction.csv.gz"

        File daskReport = "dask-report.html"
        File? log = outputPrefix + "_seqc_log.txt"
    }

    runtime {
        docker: dockerImage
        disks: "local-disk " + ceil(2 * (if inputSize < 1 then 1 else inputSize )) + " HDD"
        cpu: numCores
        memory: memoryGB + "GB"
        preemptible: 0
    }
}
