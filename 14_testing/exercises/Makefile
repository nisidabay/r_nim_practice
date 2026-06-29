CC = nim
CFLAGS = c -r
EXS = ex01_test_check ex02_fixtures ex03_expect ex04_refactor_cli
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:; rm -rf nimcache $(EXS)
