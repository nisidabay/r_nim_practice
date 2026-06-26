CC = nim
CFLAGS = c -r
EXS = ex01_safe_parse ex02_option_divide ex03_fallback ex04_write_test
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:; rm -rf nimcache
