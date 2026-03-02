VENV     := .venv
PYTHON   := $(VENV)/bin/python
PIP      := $(VENV)/bin/pip
OUT_DIR  := $(CURDIR)/data

.PHONY: help setup refresh serve clean

help:           ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*##"}{printf "  %-12s %s\n",$$1,$$2}'

setup: $(VENV)  ## Create venv, install deps, run first refresh
	$(PIP) install -q -r requirements.txt
	$(MAKE) refresh
	@echo "Done. Run: make serve"

$(VENV):
	python3 -m venv $(VENV)

refresh:        ## Fetch latest market data into ./data
	$(PYTHON) scripts/build_data.py --out-dir $(OUT_DIR)

serve:          ## Serve dashboard at http://localhost:8021
	@echo "Open http://localhost:8021"
	python3 -m http.server 8021

clean:          ## Remove generated data (keeps .gitkeep)
	find $(OUT_DIR) -mindepth 1 -not -name '.gitkeep' -delete
