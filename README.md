# SEQC Pipeline

## Tiny Chromosome 9 10x v2

```bash
./submit.sh \
    -k ~/keys/secrets-aws.json \
    -i ./configs/tiny-chr9-10x-v2.inputs.json \
    -l ./configs/tiny-chr9-10x-v2.labels.json \
    -o SEQC.options.aws.json
```

## PBMC 1K 10x v3

```bash
./submit.sh \
    -k ~/keys/secrets-aws.json \
    -i configs/pbmc-1k-10x-v3.inputs.json \
    -l configs/pbmc-1k-10x-v3.labels.json \
    -o SEQC.options.aws.json
```

## Development

### How to upgrade

`./dockers/seqc-basic-analysis`

- Update the basic analysis notebook: `notebooks/template-basic-analysis.ipynb`
- Increment the version number: `version.sh`
- Build the docker image: `build.sh`
- Push the docker image to Docker Hub: `push.sh`
