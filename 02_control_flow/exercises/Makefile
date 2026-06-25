CC = nim
CFLAGS = c 
EXS = ex01_mult_table ex02_fizzbuzz ex03_fibonacci
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:
	rm -rf nimcache
