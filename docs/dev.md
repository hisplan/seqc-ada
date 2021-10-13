# For Developers

## Development

### How to upgrade

`./dockers/seqc-basic-analysis`

- Update the basic analysis notebook: `notebooks/basic-analysis-v*.ipynb`,
- Increment the version number: `config.sh`
- Build the docker image: `build.sh`
- Push the docker image to docker registry: `push.sh`

## Testing

### Tiny Chromosome 9 10x v2

```bash
./submit.sh \
    -k ~/keys/cromwell-secrets.json \
    -i ./configs/tiny-chr9-10x-v2.inputs.json \
    -l ./configs/tiny-chr9-10x-v2.labels.json \
    -o SeqcAda.options.aws.json
```

### PBMC 1K 10x v3

```bash
./submit.sh \
    -k ~/keys/cromwell-secrets.json \
    -i configs/pbmc-1k-10x-v3.inputs.json \
    -l configs/pbmc-1k-10x-v3.labels.json \
    -o SeqcAda.options.aws.json
```
