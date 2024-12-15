#!/bin/zsh

:'
This script is used on start up, to verify during usage, that the server is running.
For this, we use the /api/tags endpoint, which should always be available.

This endpoint, we use are the following:
- GET /api/ps => provides information on the models that are currently loaded into memory
- GET /api/tags => list of models available locally & tags

READ HERE: https://github.com/ollama/ollama/blob/main/docs/api.md
'