DOCS_DIR := docs

.PHONY: all landing analysis dbt-docs clean

all: landing analysis dbt-docs

landing:
	cd docs_src && quarto render index.qmd
	cp docs_src/index.html $(DOCS_DIR)/

analysis:
	quarto render visualize/visualize.qmd
	cp visualize/index.html $(DOCS_DIR)/visualization/

dbt-docs:
	cd transform && uv run dbt docs generate --profiles-dir .
	cp transform/target/index.html \
	   transform/target/catalog.json \
	   transform/target/manifest.json \
	   $(DOCS_DIR)/dbt-docs/

clean:
	rm -f $(DOCS_DIR)/index.html
	rm -f $(DOCS_DIR)/visualization/index.html
	rm -f $(DOCS_DIR)/dbt-docs/index.html \
	      $(DOCS_DIR)/dbt-docs/catalog.json \
	      $(DOCS_DIR)/dbt-docs/manifest.json
