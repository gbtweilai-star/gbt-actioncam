#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_actioncam info
PYTHONPATH=src python -m gbt_actioncam check --payload '{}'
PYTHONPATH=src python -m gbt_actioncam run   --payload '{}'
