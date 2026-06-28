# CANFAR Ray containers

User-owned Ray clusters on the CANFAR Science Platform: a **contributed manager** session (port 5000) launches **headless worker** sessions via the `canfar` Python client.

Images extend [`astroai/base`](https://github.com/astroai/astroai-containers) (not the internal `astroai/python` bake layer, which is slim + uv/pixi only and not on Harbor).

## Images

| Image | Harbor path | Skaha type |
|-------|-------------|------------|
| `ray-manager` | `images.canfar.net/astroai/ray-manager:<tag>` | Contributed |
| `ray-worker-cpu` | `images.canfar.net/astroai/ray-worker-cpu:<tag>` | Headless |

`ray-base` is build-only (like `astroai/python`). Ray runs in a **Python 3.12 venv** (`/opt/astroai/venv/ray`) because Ray wheels are not yet available for 3.13; canfar-lab/CADC stay on the base 3.13 venv.

## Build

Requires `images.canfar.net/astroai/base:26.06` (or set `BASE_TAG`).

```bash
make build-all BUILD_TAG=local BASE_TAG=26.06
make test-containers
make test-local
```

## Docs

- [Build plan](docs/build-plan.md)
- [Integration with AstroAI](docs/integration-with-astroai.md)

## Status

Milestone A prototype: local manager + worker join, smoke task. CANFAR session API integration (Milestone B+) pending.
