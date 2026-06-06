CC = nim
CFLAGS = c -r
EXS = ex01_logger ex02_finder ex03_dirinfo
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:; rm -rf nimcache
