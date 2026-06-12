CC = nim
CFLAGS = c -r
EXS = ex01_fraction_calc ex02_rope_reader ex03_stats_report
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:; rm -rf nimcache