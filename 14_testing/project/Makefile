CC = nim
CFLAGS = c
all: filecheck
filecheck: filecheck.nim
	$(CC) $(CFLAGS) $<
run: filecheck
	./filecheck
test: filecheck
	./filecheck test_manifest.txt
clean:; rm -rf nimcache filecheck
