
Dask
===========

[![Travis Build Status](https://travis-ci.com/dask/helm-chart.svg?branch=master)](https://travis-ci.com/dask/helm-chart)
[![Chart version](https://img.shields.io/badge/dynamic/yaml?url=https://helm.dask.org/index.yaml&label=chart&query=$.entries.dask[:1].version&color=277A9F)](https://helm.dask.org/)
[![Dask version](https://img.shields.io/badge/dynamic/yaml?url=https://helm.dask.org/index.yaml&label=Dask&query=$.entries.dask[:1].appVersion&color=D67548)](https://helm.dask.org/)

- <https://dask.org>

## Chart Details

This chart will deploy the following:

- 1 x Dask scheduler with port 8786 (scheduler) and 80 (Web UI) exposed on an external LoadBalancer (default)
- 3 x Dask workers that connect to the scheduler
- All using Kubernetes Deployments

> **Tip**: See the [Kubernetes Service Type Docs](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)
> for the differences between ClusterIP, NodePort, and LoadBalancer.

## Installing the Chart

First we need to add the Dask helm repo to our local helm config.

```bash
helm repo add dask https://helm.dask.org/
helm repo update
```

To install the chart with the release name `my-release`:

```bash
helm install --name my-release dask/dask
```

Depending on how your cluster was setup, you may also need to specify
a namespace with the following flag: `--namespace my-namespace`.

### Upgrading an existing installation that used stable/dask

This chart is fully compatible with the previous chart, it is just a change of location.
If you have an existing deployment of Dask which used the now-deprecated `stable/dask` chart
you can upgrade it by changing the repo name in your upgrade command.

```bash
# Add the Dask repo if you haven't already
helm repo add dask https://helm.dask.org/
helm repo update

# Upgrade your deployment that was previous created with stable/dask
helm upgrade my-release dask/dask
```
## Configuration

The following table lists the configurable parameters of the Dask chart and their default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `scheduler.name` | Dask scheduler name. | `"scheduler"` |
| `scheduler.image.repository` | Container image repository. | `"daskdev/dask"` |
| `scheduler.image.tag` | Container image tag. | `"2.27.0"` |
| `scheduler.image.pullPolicy` | Container image pull policy. | `"IfNotPresent"` |
| `scheduler.image.pullSecrets` | Container image [pull secrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/). | `null` |
| `scheduler.replicas` | Number of schedulers (should always be 1). | `1` |
| `scheduler.serviceType` | Scheduler service type. set to `loadbalancer` to expose outside of your cluster. | `"ClusterIP"` |
| `scheduler.servicePort` | Scheduler service internal port. | `8786` |
| `scheduler.resources` | Scheduler pod resources. see `values.yaml` for example values. | `{}` |
| `scheduler.tolerations` | Tolerations. | `[]` |
| `scheduler.affinity` | Container affinity. | `{}` |
| `scheduler.nodeSelector` | Node selector. | `{}` |
| `webUI.name` | Dask webui name. | `"webui"` |
| `webUI.servicePort` | Webui service internal port. | `80` |
| `webUI.ingress.enabled` | Enable ingress. | `false` |
| `webUI.ingress.tls` | Ingress should use tls. | `false` |
| `webUI.ingress.hostname` | Ingress hostname. | `"dask-ui.example.com"` |
| `webUI.ingress.annotations` | Ingress annotations. see `values.yaml` for example values. | `null` |
| `worker.name` | Dask worker name. | `"worker"` |
| `worker.image.repository` | Container image repository. | `"daskdev/dask"` |
| `worker.image.tag` | Container image tag. | `"2.27.0"` |
| `worker.image.pullPolicy` | Container image pull policy. | `"IfNotPresent"` |
| `worker.image.dask_worker` | Dask worker command. e.g `dask-cuda-worker` for gpu worker. | `"dask-worker"` |
| `worker.image.pullSecrets` | Container image [pull secrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/). | `null` |
| `worker.replicas` | Number of workers. | `3` |
| `worker.default_resources.cpu` | Default cpu (deprecated use `resources`). | `1` |
| `worker.default_resources.memory` | Default memory (deprecated use `resources`). | `"4GiB"` |
| `worker.env` | Environment variables. see `values.yaml` for example values. | `null` |
| `worker.resources` | Worker pod resources. see `values.yaml` for example values. | `{}` |
| `worker.mounts` | Worker pod volumes and volume mounts, mounts.volumes follows kuberentes api v1 volumes spec. mounts.volumemounts follows kubernetesapi v1 volumemount spec | `{}` |
| `worker.tolerations` | Tolerations. | `[]` |
| `worker.affinity` | Container affinity. | `{}` |
| `worker.nodeSelector` | Node selector. | `{}` |
| `worker.securityContext` | Security contect. | `{}` |


## Custom Configuration

If you want to change the default parameters, you can do this in two ways.

### YAML Config Files

You can change the default parameters in `values.yaml`, or create your own
custom YAML config file, and specify this file when installing your chart with
the `-f` flag. Example:

```bash
helm install --name my-release -f values.yaml dask/dask
```

> **Tip**: You can use the default [values.yaml](/dask/values.yaml) for reference

### Command-Line Arguments

If you want to change parameters for a specific install without changing
`values.yaml`, you can use the `--set key=value[,key=value]` flag when running
`helm install`, and it will override any default values. Example:

### Customizing Python Environment

The default `daskdev/dask` images have a standard Miniconda installation along
with some common packages like NumPy and Pandas. You can install custom packages
with either Conda or Pip using optional environment variables. This happens
when your container starts up.

> **Note**: The `IP:PORT` of this chart's services will not be accessible until
> extra packages finish installing. 
> 
Consider the following YAML config as an example:

```yaml

worker:
  env:
  - name: EXTRA_CONDA_PACKAGES
    value: numba xarray -c conda-forge
  - name: EXTRA_PIP_PACKAGES
    value: s3fs dask-ml --upgrade
```


### RBAC


```bash
kubectl scale deployment dask-worker --replicas=10
```

You can also get pod logs using kubectl.

```bash
# List pods
kubectl get pods

# Watch pod logs
kubectl logs -f {podname}
```

Also see the [dask-kubernetes documentation](https://kubernetes.dask.org/en/latest/api.html#dask_kubernetes.HelmCluster)
for the `HelmCluster` cluster manager for managing workers from within your Python session.

## Maintaining

### Generating the README

This repo uses [Frigate](https://frigate.readthedocs.io/en/master/index.html) to autogenerate the README. This makes it quick to keep the table
of config options up to date.

If you wish to make a change to the README body you must edit `dask/.frigate` instead.

To generate the readme run Frigate.

```
frigate gen dask > README.md
```

### Releasing

Releases of the Helm chart are automatically pushed to the `gh-pages` branch by Travis CI when git tags are created.

Before releasing you may want to ensure the chart is up to date with the latest Docker images and Dask versions:

- Update the image tags in `dask/values.yaml` to reflect the [latest release of the Dask Docker images](https://github.com/dask/dask-docker/releases).
- Update the `appVersion` value in `dask/Chart.yaml` to also reflect this version.

Then to perform a release you need to create and push a new tag.

You can either use the `ci/release.sh` script.

```
ci/release.sh x.x.x
```

Or manually run the steps below.

- Update the `version` key in `dask/Chart.yaml` with the new chart version `x.x.x`.
- For ease of releasing set the version as an environment variable `export DASK_HELM_VERSION=x.x.x`.
- Add a release commit `git commit -a -m "bump version to $DASK_HELM_VERSION"`.
- Tag the commit `git tag -a $DASK_HELM_VERSION -m "Version $DASK_HELM_VERSION"`.
- Push the tags `git push upstream master --tags`.
- Travis CI will automatically build and release to the chart repository.


