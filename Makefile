CONCEPT_DIR = 14_testing/concept
CONCEPTS = $(CONCEPT_DIR)/why_test.nim \
           $(CONCEPT_DIR)/suites.nim \
           $(CONCEPT_DIR)/assertions.nim \
           $(CONCEPT_DIR)/fixtures.nim \
           $(CONCEPT_DIR)/testing_cli.nim \
           $(CONCEPT_DIR)/test_it.nim

ORGANIZE_RUNNER = $(CONCEPT_DIR)/organize/runtests.nim

.PHONY: test clean

test: $(CONCEPTS) $(ORGANIZE_RUNNER)
	@echo "Running all test concept files..."
	@for f in $(CONCEPTS); do \
		echo "── $$f ──"; \
		nim c -r $$f || exit 1; \
	done
	@echo "── $$(basename $$(dirname $(ORGANIZE_RUNNER)))/$$(basename $(ORGANIZE_RUNNER)) ──"; \
	nim c -r $(ORGANIZE_RUNNER) || exit 1
	@echo "All tests passed."

clean:; rm -rf nimcache
