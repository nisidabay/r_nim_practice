CONCEPT_DIR = 14_testing/concept
CONCEPTS = $(CONCEPT_DIR)/why_test.nim \
           $(CONCEPT_DIR)/suites.nim \
           $(CONCEPT_DIR)/assertions.nim \
           $(CONCEPT_DIR)/fixtures.nim \
           $(CONCEPT_DIR)/testing_cli.nim \
           $(CONCEPT_DIR)/test_it.nim

ORGANIZE_RUNNER = $(CONCEPT_DIR)/organize/runtests.nim

MEMORY_DIR = 15_memory_management/concept
MEMORY_CONCEPTS = $(MEMORY_DIR)/ref_vs_ptr.nim \
                  $(MEMORY_DIR)/raw_memory.nim \
                  $(MEMORY_DIR)/ownership.nim \
                  $(MEMORY_DIR)/casting.nim \
                  $(MEMORY_DIR)/test_it.nim

.PHONY: test memory clean

test: $(CONCEPTS) $(ORGANIZE_RUNNER)
	@echo "Running all test concept files..."
	@for f in $(CONCEPTS); do \
		echo "── $$f ──"; \
		nim c -r $$f || exit 1; \
	done
	@echo "── $$(basename $$(dirname $(ORGANIZE_RUNNER)))/$$(basename $(ORGANIZE_RUNNER)) ──"; \
	nim c -r $(ORGANIZE_RUNNER) || exit 1
	@make memory
	@echo "All tests passed."

memory: $(MEMORY_CONCEPTS)
	@echo "Running memory-management concept files..."
	@for f in $(MEMORY_CONCEPTS); do \
		echo "── $$f ──"; \
		nim c -r --hints:off $$f || exit 1; \
	done

clean:; rm -rf nimcache
