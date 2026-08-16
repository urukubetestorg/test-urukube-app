# test-urukube-app

Sample nginx app used to exercise the `platform-xp-argo-appset` GitOps golden path (see that repo's README for the full flow).

## Layout

```
helm/
  Chart.yaml
  values.yaml        # helmValuesPath default: helm/values.yaml
  templates/
    _helpers.tpl
    configmap.yaml    # renders Values.html.title/message into an nginx index.html
    deployment.yaml
    service.yaml
```

This matches the `UArgoAppSet` XRD defaults (`platform-xp-argo-appset/xrd.yaml`):

| Parameter | Default | Satisfied by |
|---|---|---|
| `helmChartPath` | `helm/` | chart root |
| `helmValuesPath` | `helm/values.yaml` | `helm/values.yaml` |

## Try it locally

```bash
helm lint helm/
helm template test-urukube-app helm/
```

## What's needed for the ApplicationSet to pick this repo up

The chart alone isn't sufficient — per `platform-xp-argo-appset`'s README ("What an app repo needs to participate"):

1. **GitHub topic**: add the topic matching the claim's `repoLabel` (e.g. `platform-preview-enabled`) to this repo's GitHub settings. This can't be done via a file in the repo — it's a repo setting.
2. **Helm chart at `helmChartPath`**: done (`helm/`).
3. **Push to a branch matching the claim's `branchPattern`** (e.g. `^main$` → push to `main`).

Once a `UArgoAppSet` claim (see `platform-xp-example-resources/argo-appset/claim-appset-dev.yaml`) is applied and `Ready`, and this repo carries the topic, the ApplicationSet's SCM generator will discover it on the next poll (`requeueSeconds`, default 180s) and ArgoCD will deploy `helm/` to namespace `test-urukube-app-<branch-slug>` on the target cluster.
