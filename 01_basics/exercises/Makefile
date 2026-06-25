CC = nim
CFLAGS = c

EXERCISES = ex01_greeting ex02_temperature

all: $(EXERCISES)

ex01_greeting: ex01_greeting.nim
	$(CC) $(CFLAGS) ex01_greeting.nim

ex02_temperature: ex02_temperature.nim
	$(CC) $(CFLAGS) ex02_temperature.nim

clean:
	rm -rf nimcache
