CC=gcc
SRC=notifier.c
EXE=mynotifier
CFLAGS=
CFLAGS+=-Wall
CFLAGS+=`pkg-config --cflags --libs libnotify`

all : $(EXE)

$(EXE) : $(SRC)
	$(CC) $(CFLAGS) -o $@ $^ 

.PHONY : clean install

clean :
	rm -f $(EXE)

install: $(EXE)
	install $(EXE) ~/mybin
	
