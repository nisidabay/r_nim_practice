CC = nim
CFLAGS = c -r
all: log_analyzer
log_analyzer: log_analyzer.nim
	$(CC) $(CFLAGS) $<
run: log_analyzer
	./log_analyzer
clean:; rm -rf nimcache log_analyzer