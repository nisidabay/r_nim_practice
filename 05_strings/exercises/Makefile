CC = nim
CFLAGS = c -r
EXS = ex01_csv ex02_url ex03_word_count
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:; rm -rf nimcache
