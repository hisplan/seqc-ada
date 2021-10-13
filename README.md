# SEQC Ada

SEQC Ada (AutomateD Analysis)

Ada is considered to be the first computer programmer and her method has been called the world's first computer program.

## Setup

The pipeline is a part of SCING (Single-Cell pIpeliNe Garden; pronounced as "sing" /siŋ/). For setup, please refer to [this page](https://github.com/hisplan/scing). All the instructions below is given under the assumption that you have already configured SCING in your environment.

## Create Job Files

You need two files for processing a sample - one inputs file and one labels file. Use the following example files to help you create your configuration file:

- `configs/template.inputs.json`
- `configs/template.labels.json`

### Assay

Type         | `SeqcAda.assay`
------------ | -----------------------------------------------------------------------------
10x v2 Kit   | `ten_x_v2`
10x v3 Kit   | `ten_x_v3`
10x NextGEM  | `ten_x_v3`

### Genome Index

Use one of the URLs below for the reference genome:

Type   | `SeqcAda.index`
------ | ---------------------------------------------
Human  | `s3://seqc-public/genomes/hg38_long_polya/`
Mouse  | `s3://seqc-public/genomes/mm38_long_polya/`

## Submit Your Job

```bash
conda activate scing

./submit.sh \
    -k ~/keys/cromwell-secrets.json \
    -i configs/your-sample.inputs.json \
    -l configs/your-sample.labels.json \
    -o SeqcAda.options.aws.json
```
