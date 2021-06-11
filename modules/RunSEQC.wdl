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
        Int memoryGB = 64
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
    >>>

    output {
        Array[File] outFiles = glob(outputPrefix + "*")
        File? outLog = "seqc_log.txt"
    }

    runtime {
        docker: dockerImage
        disks: "local-disk " + ceil(2 * (if inputSize < 1 then 1 else inputSize )) + " HDD"
        cpu: numCores
        memory: memoryGB + "GB"
        preemptible: 0
    }
}
