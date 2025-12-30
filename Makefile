.PHONY: build watch serve clean

DOCS_DIR := docs
MAIN_SCRBL := $(DOCS_DIR)/main.scrbl

build:
	cd $(DOCS_DIR) && raco make main.scrbl && scribble --html main.scrbl

watch:
	@echo "Watching for changes in $(DOCS_DIR)/*.scrbl..."
	@fswatch -r -m poll_monitor $(DOCS_DIR) | while read file; do \
		if echo "$$file" | grep -q '\.scrbl$$'; then \
			echo "Detected change in $$file, rebuilding..."; \
			make build; \
		fi; \
	done

serve:
	@echo "Serving docs at http://localhost:8000/main.html"
	cd $(DOCS_DIR) && python3 -m http.server 8000

clean:
	rm -f $(DOCS_DIR)/*.html $(DOCS_DIR)/*.js $(DOCS_DIR)/*.css
