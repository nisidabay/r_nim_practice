CC = nim
CFLAGS = c -r
EXS = ex01_phonebook ex02_set_ops ex03_letter_count
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:; rm -rf nimcache
