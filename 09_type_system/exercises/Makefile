CC = nim
CFLAGS = c -r
EXS = ex01_temperature ex02_shapes ex03_compile_fact ex04_enum
all: $(EXS)
$(EXS): %: %.nim
	$(CC) $(CFLAGS) $<
clean:; rm -rf nimcache
