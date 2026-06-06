CC = nim
CFLAGS = c -r
EXS = ex01_median ex02_transpose ex03_zip_filter ex04_enum
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:; rm -rf nimcache
