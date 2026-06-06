CC = nim
CFLAGS = c -r --threads:on
EXS = ex01_prime_parallel
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:; rm -rf nimcache
