# Helmfile Lint Action

This action lints a Helmfile deployment.

## Inputs

### `helmfile_directory`

**Required** The path to the directory where the helmfile is located

### `stage`

**Required** The environment that we would like to lint (staging or production)

## Example usage

```yaml
uses: wtag/helmfile-lint-action@master
with:
  helmfile_directory: deployment
  stage: staging
```
