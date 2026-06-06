CC = nim
CFLAGS = c -r
EXS = ex01_calculator ex02_palindrome ex03_timer
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:; rm -rf nimcache
