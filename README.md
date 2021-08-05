# SEQC Ada

SEQC Ada (AutomateD Analysis)

Ada is considered to be the first computer programmer and her method has been called the world's first computer program.

## Testing

### Tiny Chromosome 9 10x v2

```bash
./submit.sh \
    -k ~/keys/cromwell-secrets-aws-nvirginia.json \
    -i ./configs/tiny-chr9-10x-v2.inputs.json \
    -l ./configs/tiny-chr9-10x-v2.labels.json \
    -o SeqcAda.options.aws.json
```

### PBMC 1K 10x v3

```bash
./submit.sh \
    -k ~/keys/cromwell-secrets-aws-nvirginia.json \
    -i configs/pbmc-1k-10x-v3.inputs.json \
    -l configs/pbmc-1k-10x-v3.labels.json \
    -o SeqcAda.options.aws.json
```

## Development

### How to upgrade

`./dockers/seqc-basic-analysis`

- Update the basic analysis notebook: `notebooks/basic-analysis-v*.ipynb`,
- Increment the version number: `config.sh`
- Build the docker image: `build.sh`
- Push the docker image to docker registry: `push.sh`
