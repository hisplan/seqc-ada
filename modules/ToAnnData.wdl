version 1.0

task ToAnnData {

    input {
        String sampleName
        File denseMatrix
        File sparseBarcodes
        File sparseGenes
        File sparseMoleculeCounts
        File sparseReadCounts

        # docker-related
        String dockerRegistry
    }

    String dockerImage = dockerRegistry + "/seqc-basic-analysis:0.0.4"

    command <<<
        set -euo pipefail

        mkdir -p data
        mv ~{denseMatrix} data/
        mv ~{sparseBarcodes} data/
        mv ~{sparseGenes} data/
        mv ~{sparseMoleculeCounts} data/
        mv ~{sparseReadCounts} data/

        papermill \
            /opt/to-adata.ipynb to-adata.ipynb \
            --parameters path_data data \
            --parameters sample_name ~{sampleName} \
            --stdout-file notebook.stdout.txt
    >>>

    output {
        File filteredH5ad = sampleName + ".filtered.h5ad"
        File rawH5ad = sampleName + ".raw.h5ad"
        File notebookStdout = "notebook.stdout.txt"
    }

    runtime {
        docker: dockerImage
        disks: "local-disk 10 HDD"
        cpu: 1
        memory: "32 GB"
    }
}
