CC = nim
CFLAGS = c -r
EXS = ex01_csv ex02_url
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:; rm -rf nimcache
