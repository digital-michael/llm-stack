
# GOALS
Using Docker, docker compose file and support BASH scripts, stand up a LLM (Large Language Model) with a web interface using a private docker network.

## Components
- OpenWeb UI - web front end for LLM
- Ollama - LLM server

### Future Expansion
- (future) Rag-Placehold 
- (future) Postgres for vector data storage

## CONFIGURE
Note: read on first run of Create. To activate changes, you must destroy and run create again.
```.env
# Postgres Config
POSTGRES_DB=ragdb
POSTGRES_USER=raguser
POSTGRES_PASSWORD=changeme

# Ollama

# Web UI
WEBUI_PORT=3000
WEBUI_AUTH_DISABLED=false

# GPU Support — use 'nvidia' if you have NVIDIA GPUs and NVIDIA Container Toolkit, else leave as 'runc'
#GPU_RUNTIME=runc
GPU_RUNTIME=nvidia
```

## CREATE
```shell
sudo bash -C create.sh
```

## INIT MODELS (on first create)
After the create has finished starting all services, this script (with no arguments) will load models by default: "llama3" "qwen:0.5b" "qwen:1.8b"

Note: if you provide a CLI argument like "quen3:0.6b", it will try to load that model instead of the defaults.
```shell
sudo bash -C scripts/inject_model_defaults.sh
```

## START
```shell
sudo bash -C start.sh
```

## STOP
```shell
sudo bash -C stop.sh
```

## DESTROY
```shell
sudo bash -C destroy.sh
```
