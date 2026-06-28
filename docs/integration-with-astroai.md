# Integration with astroai/containers

## Parent image: `astroai/base`, not `astroai/python`

| Layer | Contents | On Harbor? |
|-------|----------|------------|
| `python:3.13-slim` | Upstream Debian Python | — |
| `astroai/python` | slim + uv + pixi + micromamba | **No** (bake-only) |
| `astroai/base` | CADC/canfar-lab, compilers, session profile | **Yes** |
| `astroai/ray-base` | base + pinned Ray + astronomy deps | **No** (bake-only) |

Ray images inherit session env (`CANFAR_LAB_*`, `/arc`, `/scratch`) from astroai/base without duplicating the profile stack.

## Storage

Same model as [AstroAI USAGE](https://github.com/astroai/containers/blob/main/docs/USAGE.md):

- Durable output → `/arc/projects/...`
- Ray spill/temp → `/scratch/ray/<cluster-id>/`
- Manager state → `~/.canfar-ray/clusters/<id>/` on `/arc/home`

## When to use which

| Need | Use |
|------|-----|
| Interactive dev, notebooks, agents | AstroAI `webterm` / `vscode` / `notebook` |
| Multi-session distributed Ray | `ray-manager` + auto-launched workers |
| Single-node Ray in a dev session | `pixi add ray` in your project (no special image) |

## Registry

All published under Harbor project **`astroai`**: `ray-manager`, `ray-worker-cpu` (GPU variant planned).
