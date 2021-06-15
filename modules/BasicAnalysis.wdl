version 1.0

task BasicAnalysis {

    input {

    }

    command <<<
        set -euo pipefail

        papermill \
            /opt/template-basic-analysis.ipynb basic-analysis.ipynb \
            -p path ./input-data
    >>>

    output {
        File outNotebook = "basic-analysis.ipynb"
    }

    runtime {
        docker: "hisplan/seqc-basic-analysis:0.0.1"
        disks: "local-disk 10 HDD"
        cpu: 1
        memory: "4 GB"
    }
}
