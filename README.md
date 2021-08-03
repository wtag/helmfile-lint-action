# Helmfile Lint Action

This action lints a Helmfile deployment.

## Why do we care?

To catch mistakes early on, we want to test as many helm chart configuration as we can.

https://github.com/wtag/helm-lint-action is another action we made that will test a single chart (generally the chart to deploy the application).

This action allows us to **test every chart present in a helmfile**.

## Handling `secrets.yaml`

### The problem

We are stuck with a dilemma.

On one hand, we do not want GitHub or any other third-party services to know about secrets of our applications.

On the other hand, we want to test as much as we can of the helm charts we are going to deploy. A great way to do this is to use the `helmfile template` and `helmfile lint` commands, which are **testing every helm release we will make**.

Unfortunately, those commands use the `secrets.yaml` files, but we do not have access to them from the CI.

### The workaround

In this action, we are recreating every `secret.yaml` files:

- The keys are **exactly the same as the original `secret.yaml` file**
- All values are set to the `"dummy"` string
- The `secrets.yaml` are **re-encrypted using a local `gpg` encryption**.

This will allow us to be able to **run `helmfile template` and `helmfile lint` without making a single change to the helmfile of the application**.

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
