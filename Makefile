.PHONY: build watch serve clean

DOCS_DIR := docs

build:
	cd $(DOCS_DIR) && raco pollen render

watch:
	@echo "Starting Pollen dev server at http://localhost:8080..."
	cd $(DOCS_DIR) && raco pollen start

serve: watch

clean:
	cd $(DOCS_DIR) && raco pollen reset
