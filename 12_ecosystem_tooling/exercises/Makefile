CC = nim
CFLAGS = c -r
EXS = ex01_config_shell ex02_csv_log_stats ex03_url_router
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:; rm -rf nimcache