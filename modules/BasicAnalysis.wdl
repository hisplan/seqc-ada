version 1.0

task BasicAnalysis {

    input {
        String sampleName
        File pathRawAdata
        File pathFilteredAdata

        # docker-related
        String dockerRegistry
    }

    String dockerImage = dockerRegistry + "/seqc-basic-analysis:0.0.4"

    command <<<
        set -euo pipefail

        papermill \
            /opt/template-basic-analysis.ipynb ~{sampleName}.basic-analysis.ipynb \
            --parameters path_raw_adata ~{pathRawAdata} \
            --parameters path_filtered_adata ~{pathFilteredAdata} \
            --stdout-file notebook.stdout.txt
    >>>

    output {
        File notebook = sampleName + ".basic-analysis.ipynb"
        File notebookStdout = "notebook.stdout.txt"
    }

    runtime {
        docker: dockerImage
        disks: "local-disk 10 HDD"
        cpu: 1
        memory: "4 GB"
    }
}
