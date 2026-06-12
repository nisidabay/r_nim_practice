CC = nim
CFLAGS = c -r
EXS = ex01_json_stats ex02_file_org ex03_modular_cli/main
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:; rm -rf nimcache